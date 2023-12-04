function dist = DistBtn2Dpose(pose1, pose2) 
    dist = sqrt( (pose1(1) - pose2(1))^2 + (pose1(2) - pose2(2))^2);   
end
