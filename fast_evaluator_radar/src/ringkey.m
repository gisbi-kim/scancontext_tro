function [ ring_key ] = ringkey(sc)

num_rings = size(sc, 1);

ring_key = zeros(1, num_rings);
for ith=1:num_rings
    ith_ring = sc(ith,:);
    ring_key(ith) = mean(ith_ring);
end

end

