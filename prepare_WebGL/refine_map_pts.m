function [ map_pts ] = refine_map_pts( map_pts,floorplan_pts,p2m )
fp=floorplan_pts{1};
dis=norm(fp(1,:)-fp(2,:))/p2m*4;
dis2=norm(map_pts(1,:)-map_pts(2,:));
map_pts(2,:)=(map_pts(2,:)-map_pts(1,:))/dis2*dis+map_pts(1,:);
end