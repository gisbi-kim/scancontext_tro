import time
import numpy as np
from scipy.spatial import KDTree

def timing(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        elapsed = (time.time() - start) * 1000.0  # ms
        print(f"* [Timing] {func.__name__} took {elapsed:.4f} ms")
        return result
    return wrapper

def xy2theta(x, y):
    angle = np.degrees(np.arctan2(y, x))
    return angle % 360

def circshift(mat, num_shift):
    return np.roll(mat, shift=num_shift, axis=1)

def dist_direct_sc(sc1, sc2):
    valid_cols = np.logical_and(np.linalg.norm(sc1, axis=0) > 0, np.linalg.norm(sc2, axis=0) > 0)
    if not np.any(valid_cols):
        return 1.0
    similarities = np.einsum('ij,ij->j', sc1[:, valid_cols], sc2[:, valid_cols])
    norms = np.linalg.norm(sc1[:, valid_cols], axis=0) * np.linalg.norm(sc2[:, valid_cols], axis=0)
    similarities /= norms
    return 1.0 - np.mean(similarities)


class ScanContext:
    def __init__(self, num_ring=20, num_sector=60, max_radius=80.0, lidar_height=2.0):
        self.num_ring = num_ring
        self.num_sector = num_sector
        self.max_radius = max_radius
        self.lidar_height = lidar_height
        self.unit_sector_angle = 360.0 / self.num_sector
        self.pc_unit_ringgap = self.max_radius / self.num_ring

        # Descriptor 저장소
        self.descs = []
        self.ring_keys = []
        self.sector_keys = []
        self.inv_key_mat = []
        self.timestamps = []  # <<<<<< 추가됨

        # KDTree
        self.kdtree = None

        # 하이퍼파라미터
        self.sample_step = 50
        self.exclude_recent = 50
        self.num_candidates = 3
        self.search_ratio = 0.1
        self.dist_thres = 0.13
        self.tree_period = 50
        self.tree_counter = 0

    @timing
    def make_descriptor(self, pointcloud, sample_step=50):
        NO_POINT = -1000.0
        desc = NO_POINT * np.ones((self.num_ring, self.num_sector))

        for i in range(0, pointcloud.shape[0], sample_step):
            x, y, z = pointcloud[i]
            z += self.lidar_height
            r = np.sqrt(x ** 2 + y ** 2)
            if r > self.max_radius:
                continue

            angle = xy2theta(x, y)
            ring_idx = min(self.num_ring - 1, int((r / self.max_radius) * self.num_ring))
            sector_idx = min(self.num_sector - 1, int((angle / 360.0) * self.num_sector))

            desc[ring_idx, sector_idx] = max(desc[ring_idx, sector_idx], z)

        desc[desc == NO_POINT] = 0.0
        return desc

    def make_ring_key(self, desc):
        return np.mean(desc, axis=1).reshape(-1, 1)

    def make_sector_key(self, desc):
        return np.mean(desc, axis=0).reshape(1, -1)

    def fast_align_using_vkey(self, vkey1, vkey2):
        best_shift = 0
        min_norm = float('inf')
        for shift in range(vkey1.shape[1]):
            shifted = circshift(vkey2, shift)
            diff = np.linalg.norm(vkey1 - shifted)
            if diff < min_norm:
                min_norm = diff
                best_shift = shift
        return best_shift

    def distance_between_descs(self, sc1, sc2):
        vkey1 = self.make_sector_key(sc1)
        vkey2 = self.make_sector_key(sc2)
        base_shift = self.fast_align_using_vkey(vkey1, vkey2)

        search_radius = int(0.5 * self.search_ratio * sc1.shape[1])
        shifts = [(base_shift + i) % sc1.shape[1] for i in range(-search_radius, search_radius + 1)]

        best_dist = float('inf')
        best_shift = 0
        for shift in shifts:
            shifted = circshift(sc2, shift)
            d = dist_direct_sc(sc1, shifted)
            if d < best_dist:
                best_dist = d
                best_shift = shift
        return best_dist, best_shift

    def add_descriptor(self, pointcloud, timestamp=None):
        desc = self.make_descriptor(pointcloud, self.sample_step)
        ring_key = self.make_ring_key(desc)
        sector_key = self.make_sector_key(desc)

        self.descs.append(desc)
        self.ring_keys.append(ring_key)
        self.sector_keys.append(sector_key)
        self.inv_key_mat.append(ring_key.flatten())

        if timestamp is not None:
            self.timestamps.append(timestamp)
        else:
            self.timestamps.append(-1.0)

    @timing
    def build_tree(self):
        if len(self.inv_key_mat) < self.exclude_recent + 1:
            return
        data = self.inv_key_mat[:-self.exclude_recent]
        self.kdtree = KDTree(data)

    @timing
    def find_nearest(self):
        if len(self.inv_key_mat) < self.exclude_recent + 1:
            return -1, 0.0, float('inf')

        if self.tree_counter % self.tree_period == 0:
            self.build_tree()
        self.tree_counter += 1

        curr_key = self.inv_key_mat[-1]
        curr_desc = self.descs[-1]
        dists, idxs = self.kdtree.query(curr_key, k=self.num_candidates)

        best_id, best_dist, best_yaw = -1, float('inf'), 0
        for i in idxs:
            sc2 = self.descs[i]
            dist, yaw_shift = self.distance_between_descs(curr_desc, sc2)
            if dist < best_dist:
                best_dist = dist
                best_id = i
                best_yaw = yaw_shift

        return best_id, best_yaw, best_dist
