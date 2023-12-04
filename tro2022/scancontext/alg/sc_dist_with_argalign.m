function [dist, argalign] = sc_dist_with_argaling(sc1, sc2)

num_sectors = size(sc1, 2);

% repeate to move 1 columns 
sim_for_each_cols = zeros(1, num_sectors);

for i = 1:num_sectors 
    %% Shift 
    one_step = 1; % const 
    sc1 = circshift(sc1, one_step, 2); % 2 means columne shift 

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
    sim_for_each_cols(i) = sum_of_cos_sim/num_col_engaged;
    
end

% sim = max(sim_for_each_cols);
[sim, argsim] = max(sim_for_each_cols);

argalign = argsim;

dist = 1 - sim;

end
