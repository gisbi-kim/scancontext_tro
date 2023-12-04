function [ nearest_idx, min_dist ] = find_topk_from_candidates(query_img, query_idx, candidates, thres)

global num_node_enough_apart; 
global radar_imgs;

nearest_idx = 0;
min_dist = inf; % initialization 
for ith_candidate = 1:length(candidates)
    candidate_node_idx = candidates(ith_candidate);
    candidate_img = radar_imgs{candidate_node_idx};

    if( abs(query_idx - candidate_node_idx) < num_node_enough_apart)
        continue;
    end

    distance_to_query = dist(query_img, candidate_img);
    if( distance_to_query > thres)
        continue; 
    end

    if( distance_to_query < min_dist)
        nearest_idx = candidate_node_idx;
        min_dist = distance_to_query;
    end     
end

end

