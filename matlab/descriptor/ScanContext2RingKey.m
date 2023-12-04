function [ ring_key ] = ScanContext2RingKey(sc)

num_rings = size(sc, 1);
num_sectors = size(sc, 2);

ring_key = zeros(1, num_rings);
for ith=1:num_rings
    ith_ring = sc(ith,:);
    num_zeros_ith_shell = nnz(~ith_ring); 
    ring_key(ith) = (num_sectors - num_zeros_ith_shell)/num_sectors;
end

end

