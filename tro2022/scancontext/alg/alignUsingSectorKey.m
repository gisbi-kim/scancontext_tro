function [init_rot] = alignUsingSectorKey(query_sk, candidate_sk)

min_rmse = inf;
init_rot = 0;
for ii = 1:length(candidate_sk)
    shifted_candidate_sk = circshift(candidate_sk, ii, 2);
    rmse = norm(query_sk - shifted_candidate_sk);
    if( rmse < min_rmse)
        min_rmse = rmse; 
        init_rot = ii;
    end
end

end

