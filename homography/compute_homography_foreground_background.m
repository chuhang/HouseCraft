function [ projectedhomography_foreground_background ] = compute_homography_foreground_background( camxyz,orientation,tilt,homography_bot,homography_top,horizontal_expand,inner_ratio_vert,inner_ratio_hori,outer_ratio_vert,outer_ratio_hori,map_pts,img_data,f,display )
%compute render
mapmid=(map_pts(1,:)+map_pts(2,:))/2;

pts(1,:)=(map_pts(1,:)-mapmid)*horizontal_expand*inner_ratio_hori+mapmid;
pts(2,:)=(map_pts(2,:)-mapmid)*horizontal_expand*inner_ratio_hori+mapmid;
rendermap_pts=[pts;pts];
vertcords=[homography_bot;homography_bot;homography_top;homography_top;]*inner_ratio_vert;
rendermap_pts=[rendermap_pts,vertcords];
cd ../render_floorplan
[ renderhomography ] = transform_3d( rendermap_pts,camxyz,orientation,tilt );
cd ../homography
projectedhomography_foreground=[renderhomography(:,1)./renderhomography(:,3)*f+size(img_data,2)/2,renderhomography(:,2)./renderhomography(:,3)*f+size(img_data,1)/2];

pts(1,:)=(map_pts(1,:)-mapmid)*(horizontal_expand+outer_ratio_hori)+mapmid;
pts(2,:)=(map_pts(1,:)-mapmid)*horizontal_expand+mapmid;
rendermap_pts=[pts;pts];
vertcords=[homography_bot;homography_bot;homography_top;homography_top;];
rendermap_pts=[rendermap_pts,vertcords];
cd ../render_floorplan
[ renderhomography ] = transform_3d( rendermap_pts,camxyz,orientation,tilt );
cd ../homography
projectedhomography_background1=[renderhomography(:,1)./renderhomography(:,3)*f+size(img_data,2)/2,renderhomography(:,2)./renderhomography(:,3)*f+size(img_data,1)/2];

pts(1,:)=(map_pts(2,:)-mapmid)*horizontal_expand+mapmid;
pts(2,:)=(map_pts(2,:)-mapmid)*(horizontal_expand+outer_ratio_hori)+mapmid;
rendermap_pts=[pts;pts];
vertcords=[homography_bot;homography_bot;homography_top;homography_top;];
rendermap_pts=[rendermap_pts,vertcords];
cd ../render_floorplan
[ renderhomography ] = transform_3d( rendermap_pts,camxyz,orientation,tilt );
cd ../homography
projectedhomography_background2=[renderhomography(:,1)./renderhomography(:,3)*f+size(img_data,2)/2,renderhomography(:,2)./renderhomography(:,3)*f+size(img_data,1)/2];

pts(1,:)=(map_pts(1,:)-mapmid)*horizontal_expand+mapmid;
pts(2,:)=(map_pts(2,:)-mapmid)*horizontal_expand+mapmid;
rendermap_pts=[pts;pts];
vertcords=[homography_top;homography_top;homography_top*(1+outer_ratio_vert);homography_top*(1+outer_ratio_vert);];
rendermap_pts=[rendermap_pts,vertcords];
cd ../render_floorplan
[ renderhomography ] = transform_3d( rendermap_pts,camxyz,orientation,tilt );
cd ../homography
projectedhomography_background3=[renderhomography(:,1)./renderhomography(:,3)*f+size(img_data,2)/2,renderhomography(:,2)./renderhomography(:,3)*f+size(img_data,1)/2];

pts(1,:)=(map_pts(1,:)-mapmid)*horizontal_expand+mapmid;
pts(2,:)=(map_pts(2,:)-mapmid)*horizontal_expand+mapmid;
rendermap_pts=[pts;pts];
vertcords=[homography_bot*(1+outer_ratio_vert);homography_bot*(1+outer_ratio_vert);homography_bot;homography_bot;];
rendermap_pts=[rendermap_pts,vertcords];
cd ../render_floorplan
[ renderhomography ] = transform_3d( rendermap_pts,camxyz,orientation,tilt );
cd ../homography
projectedhomography_background4=[renderhomography(:,1)./renderhomography(:,3)*f+size(img_data,2)/2,renderhomography(:,2)./renderhomography(:,3)*f+size(img_data,1)/2];

projectedhomography_foreground_background.foreground=projectedhomography_foreground;
projectedhomography_foreground_background.background1=projectedhomography_background1;
projectedhomography_foreground_background.background2=projectedhomography_background2;
projectedhomography_foreground_background.background3=projectedhomography_background3;
projectedhomography_foreground_background.background4=projectedhomography_background4;

if display==1
    figure;
    imshow(img_data);
    hold on;
    plot([projectedhomography_background1(1,1),projectedhomography_background1(2,1),projectedhomography_background1(4,1),projectedhomography_background1(3,1),projectedhomography_background1(1,1)],[projectedhomography_background1(1,2),projectedhomography_background1(2,2),projectedhomography_background1(4,2),projectedhomography_background1(3,2),projectedhomography_background1(1,2)],'m-','LineWidth',4);
    plot([projectedhomography_background2(1,1),projectedhomography_background2(2,1),projectedhomography_background2(4,1),projectedhomography_background2(3,1),projectedhomography_background2(1,1)],[projectedhomography_background2(1,2),projectedhomography_background2(2,2),projectedhomography_background2(4,2),projectedhomography_background2(3,2),projectedhomography_background2(1,2)],'m-','LineWidth',4);
    plot([projectedhomography_background3(1,1),projectedhomography_background3(2,1),projectedhomography_background3(4,1),projectedhomography_background3(3,1),projectedhomography_background3(1,1)],[projectedhomography_background3(1,2),projectedhomography_background3(2,2),projectedhomography_background3(4,2),projectedhomography_background3(3,2),projectedhomography_background3(1,2)],'m-','LineWidth',4);
    plot([projectedhomography_background4(1,1),projectedhomography_background4(2,1),projectedhomography_background4(4,1),projectedhomography_background4(3,1),projectedhomography_background4(1,1)],[projectedhomography_background4(1,2),projectedhomography_background4(2,2),projectedhomography_background4(4,2),projectedhomography_background4(3,2),projectedhomography_background4(1,2)],'m-','LineWidth',4);
    plot([projectedhomography_foreground(1,1),projectedhomography_foreground(2,1),projectedhomography_foreground(4,1),projectedhomography_foreground(3,1),projectedhomography_foreground(1,1)],[projectedhomography_foreground(1,2),projectedhomography_foreground(2,2),projectedhomography_foreground(4,2),projectedhomography_foreground(3,2),projectedhomography_foreground(1,2)],'c-','LineWidth',4);
    hold off;
end
