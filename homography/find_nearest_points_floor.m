function [ outpoints2d,outpoints3d,outfns ] = find_nearest_points_floor( linesorrects,points2d,points3d,fns )
for ii=1:size(linesorrects,1)
    dist=sqrt((points2d(:,1)-linesorrects(ii,1)).^2+(points2d(:,2)-linesorrects(ii,2)).^2);
    [~,idx]=sort(dist,'ascend');
    ptidx=idx(1);
    outpoints2d(ii,1:2)=points2d(ptidx,:);
    outpoints3d(ii,1:3)=points3d(ptidx,:);
    outfns(ii,1)=fns(ptidx,:);
    dist=sqrt((points2d(:,1)-linesorrects(ii,3)).^2+(points2d(:,2)-linesorrects(ii,4)).^2);
    [~,idx]=sort(dist,'ascend');
    ptidx=idx(1);
    outpoints2d(ii,3:4)=points2d(ptidx,:);
    outpoints3d(ii,4:6)=points3d(ptidx,:);
    outfns(ii,2)=fns(ptidx,:);
end
end