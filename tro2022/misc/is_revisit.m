function [ revisitness ] = is_revisit(query_idx, query_pose, radar_poses, revisit_criteria, num_node_enough_apart)

num_db = size(radar_poses, 1);

revisitness = 0;
for ii = 1:num_db
    
    if( abs(query_idx - ii) < num_node_enough_apart)
        continue;
    end
    
    pose = radar_poses(ii, :);
    
    dist = dist_btn_pose(query_pose, pose);
  
    if(dist < revisit_criteria)
        revisitness = 1;
        break;
    end    
end

end

