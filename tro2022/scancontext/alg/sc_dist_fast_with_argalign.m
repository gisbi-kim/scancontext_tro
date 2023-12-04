function [dist, argalign] = sc_dist_fast_with_argalign(sc1_in, sc2, init_rot, search_ratio)

num_sectors = size(sc1_in, 2);

%% shrinked search space 
search_space_ratio = 0.5 * search_ratio;

yaws_to_search = [];
yaws_to_search = [yaws_to_search, init_rot];
for ii = 1:ceil(search_space_ratio * num_sectors)
    yaws_to_search = [ yaws_to_search, rem(init_rot - ii, num_sectors) ];
    yaws_to_search = [ yaws_to_search, rem(init_rot + ii, num_sectors) ];
end
yaws_to_search = sort(yaws_to_search);

%% search
sim_for_each_cols = zeros(1, length(yaws_to_search));
for ii = 1:length(yaws_to_search)
    %% Shift 
    ii_shift = yaws_to_search(ii);
    sc1 = circshift(sc1_in, ii_shift, 2); % 2 means columne shift 

    %% compare
    sum_of_cos_sim = 0;
    num_col_engaged = 0;
    
    for j = 1:num_sectors 
        col_j_1 = sc1(:,j);
        col_j_2 = sc2(:,j);
        
        if( ~any(col_j_1) || ~any(col_j_2))
           continue;  
        end

        % calc sim
        cos_similarity = dot(col_j_1, col_j_2) / (norm(col_j_1)*norm(col_j_2));
        sum_of_cos_sim = sum_of_cos_sim + cos_similarity;
        
        num_col_engaged = num_col_engaged +1; 
    end 
    
    % devided by num_col_engaged: So, even if there are many columns that are excluded from the calculation, we can get high scores if other columns are well fit.
    sim_for_each_cols(ii) = sum_of_cos_sim/num_col_engaged;
    
end

[sim, argsim] = max(sim_for_each_cols);

argalign = yaws_to_search(argsim);

dist = 1 - sim;

end
