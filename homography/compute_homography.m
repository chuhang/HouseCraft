function [ projectedhomography ] = compute_homography( camxyz,orientation,tilt,homography_bot,homography_top,horizontal_expand,map_pts,img_data,f,display )
%compute render
mapmid=(map_pts(1,:)+map_pts(2,:))/2;
map_pts(1,:)=(map_pts(1,:)-mapmid)*horizontal_expand+mapmid;
map_pts(2,:)=(map_pts(2,:)-mapmid)*horizontal_expand+mapmid;
rendermap_pts=[map_pts;map_pts];
vertcords=[homography_bot;homography_bot;homography_top;homography_top;];
rendermap_pts=[rendermap_pts,vertcords];
cd ../render_floorplan
[ renderhomography ] = transform_3d( rendermap_pts,camxyz,orientation,tilt );
cd ../homography
projectedhomography=[renderhomography(:,1)./renderhomography(:,3)*f+size(img_data,2)/2,renderhomography(:,2)./renderhomography(:,3)*f+size(img_data,1)/2];

if display==1
    figure;
    imshow(img_data);
    hold on;
    plot([projectedhomography(1,1),projectedhomography(2,1),projectedhomography(4,1),projectedhomography(3,1),projectedhomography(1,1)],[projectedhomography(1,2),projectedhomography(2,2),projectedhomography(4,2),projectedhomography(3,2),projectedhomography(1,2)],'c-','LineWidth',4);
    hold off;
end
