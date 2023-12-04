function [bool_revisit, relative_angle_deg] = isNonSameDirectionRevisit( submap_traj1, submap_traj2 )
    % return direction 0 (same) or 1 (reverse)
    bool_revisit = 0;

    traj1_moving_vec = [submap_traj1(end, 1) - submap_traj1(1, 1), submap_traj1(end, 2) - submap_traj1(1, 2)];
    traj2_moving_vec = [submap_traj2(end, 1) - submap_traj2(1, 1), submap_traj2(end, 2) - submap_traj2(1, 2)];

    unit_dot = dot(traj1_moving_vec, traj2_moving_vec) ...
                / (norm(traj1_moving_vec) * norm(traj2_moving_vec));

    relative_angle_deg = rad2deg(acos(unit_dot));

    %     disp(unit_dot)
    if( unit_dot < 0.2 ) % 0.2 used for not sameness direction 
        bool_revisit = 1;
    end

end
