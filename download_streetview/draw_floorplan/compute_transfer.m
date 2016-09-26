function [ floorplan2map ] = compute_transfer( floorplan_pts,map_pts )
floorplan2map.t1=floorplan_pts(1,:);

theta1=atan2(floorplan_pts(2,2)-floorplan_pts(1,2),floorplan_pts(2,1)-floorplan_pts(1,1));
theta2=atan2(map_pts(2,2)-map_pts(1,2),map_pts(2,1)-map_pts(1,1));
deltatheta=theta1-theta2;
floorplan2map.r=[cos(deltatheta),sin(deltatheta);-sin(deltatheta),cos(deltatheta);];

len1=sqrt(sum((floorplan_pts(1,:)-floorplan_pts(2,:)).^2));
len2=sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2));
floorplan2map.s=len2/len1;

floorplan2map.t2=map_pts(1,:);
end