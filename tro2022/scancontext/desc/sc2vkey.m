function [ sector_key ] = sc2vkey(sc)

num_sectors = size(sc, 2);

sector_key = zeros(1, num_sectors);
for ith = 1:num_sectors
    ith_sector = sc(:, ith);
    sector_key(ith) = mean(ith_sector);
end

end

