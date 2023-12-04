import numpy as np
def distance_sc(sc1, sc2):
    num_sectors = sc1.shape[1]
    # repeate to move 1 columns
    sim_for_each_cols = np.zeros(num_sectors)

    for i in range(num_sectors):
        # Shift
        one_step = 1 # const
        sc1 = np.roll(sc1, one_step, axis=1) #  columne shift

        #compare
        sum_of_cos_sim = 0
        num_col_engaged = 0

        for j in range(num_sectors):
            col_j_1 = sc1[:, j]
            col_j_2 = sc2[:, j]

            if (~np.any(col_j_1) or ~np.any(col_j_2)):
                continue

            # calc sim
            cos_similarity = np.dot(col_j_1, col_j_2) / (np.linalg.norm(col_j_1) * np.linalg.norm(col_j_2))
            sum_of_cos_sim = sum_of_cos_sim + cos_similarity

            num_col_engaged = num_col_engaged + 1

        # devided by num_col_engaged: So, even if there are many columns that are excluded from the calculation, we
        # can get high scores if other columns are well fit.
        sim_for_each_cols[i] = sum_of_cos_sim / num_col_engaged

    sim = max(sim_for_each_cols)

    dist = 1 - sim

    return dist

if __name__ == "__main__":
    from python.make_sc_example import *
    bin_dir = '../sample_data/KITTI/00/velodyne/'
    bin_db = kitti_vlp_database(bin_dir)
    SCs = []
    for bin_idx in range(bin_db.num_bins):
        bin_file_name = bin_db.bin_files[bin_idx]
        bin_path = bin_db.bin_dir + bin_file_name

        sc = ScanContext(bin_dir, bin_file_name)

        # fig_idx = 1
        # # sc.plot_multiple_sc(fig_idx)
        #
        # print(len(sc.SCs))

        SCs.append(sc.SCs[0])

    sc_1a = SCs[0]
    sc_1b = SCs[1]
    sc_2a = SCs[2]
    sc_2b = SCs[3]

    dist_1a_1b = distance_sc(sc_1a, sc_1b)
    dist_1b_2a = distance_sc(sc_1b, sc_2a)
    dist_1a_2a = distance_sc(sc_1a, sc_2a)
    dist_2a_2b = distance_sc(sc_2a, sc_2b)

    print("--------------------")
    print(dist_1a_1b)
    print(dist_1b_2a)
    print(dist_1a_2a)
    print(dist_2a_2b)

