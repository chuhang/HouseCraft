function [ all_img_data,all_renderlinerects_homography_batched,all_transformed_image,all_renderlinerects_homography,goodimages,all_foreground_prob_rgb,all_foreground_prob_hsv,all_tform,all_wallloss,all_windowloss,all_doorloss,label ] = efficient_render_init( houseid,display )
%-----load data, specify parameters
cd(['../rent_crawler/goodhouses/house',int2str(houseid)]);
load('floorplan_label_data.mat');
load('groundtruth_data.mat');
load('location_data.mat');
load('goodimages.mat');
map=imread('map.png');
for ii=1:3
    img_data=imread(['img',int2str(ii),'.png']);
    all_img_data{ii}=img_data;
end
focal_len=300;
homography_bot=-4;
homography_top=floor_num*20;
horizontal_expand=3;
homography_upsample_rate=10;
xrange=40;
yrange=40;

%-----step 1: shifting center to GT to make debug easier (shift back to init location in step 11 when compute features)
cd ../../../prepare_WebGL
[ map_pts ] = refine_map_pts( map_pts,floorplan_pts,pixel2m );
ang=atan2(map_pts(2,2)-map_pts(1,2),map_pts(2,1)-map_pts(1,1));
xtmp=[cos(ang),sin(ang)];
ytmp=[cos(ang+pi/2),sin(ang+pi/2)];
map_pts(1,:)=map_pts(1,:)+gtXY(1)*xtmp+gtXY(2)*ytmp;
map_pts(2,:)=map_pts(2,:)+gtXY(1)*xtmp+gtXY(2)*ytmp;

%-----step 2: read floorplan labels
cd ../proc_floorplan_label
for fn=1:floor_num
    [ walls,wallcorners,windows,doors,dooredges,windowedges,imgsize ] = proc_floorplan_label( ['../rent_crawler/goodhouses/house',int2str(datanum),'/floorplan_label',int2str(fn),'.png'],0 );
    [ frontalwalls ] = get_frontal_facade( walls,windows,doors,floorplan_pts{fn},0 );
    [ doorpoints,windowpoints,wallpoints ] = pointalize_floorplan_scale( doors,windows,frontalwalls,pixel2m,0 );
    walls_all{fn}=walls;wallcorners_all{fn}=wallcorners;windows_all{fn}=windows;doors_all{fn}=doors;dooredges_all{fn}=dooredges;windowedges_all{fn}=windowedges;imgsize_all{fn}=imgsize;
    doorpoints_all{fn}=doorpoints;windowpoints_all{fn}=windowpoints;wallpoints_all{fn}=wallpoints;
%     %variable for exact visibility inference
%     frontalwalls_all{fn}=frontalwalls;
end

%-----step 3: transfer to map coordinate (I know the folder name doesn't make much sense...)
cd ../download_streetview/draw_floorplan
for fn=1:floor_num
    [ floorplan2map ] = compute_transfer( floorplan_pts{fn},map_pts );
    [ tmpwalls,tmpwallcorners,tmpwindows,tmpdoors,tmpdooredges,tmpwindowedges,tmpdoorpoints,tmpwindowpoints,tmpwallpoints ] = transfer_lable_cors( walls_all{fn},wallcorners_all{fn},windows_all{fn},doors_all{fn},dooredges_all{fn},windowedges_all{fn},floorplan2map,doorpoints_all{fn},windowpoints_all{fn},wallpoints_all{fn},map,0 );
    mapwalls{fn}=tmpwalls;mapwallcorners{fn}=tmpwallcorners;mapwindows{fn}=tmpwindows;
    mapdoors{fn}=tmpdoors;mapdooredges{fn}=tmpdooredges;mapwindowedges{fn}=tmpwindowedges;
    mapdoorpoints{fn}=tmpdoorpoints;mapwindowpoints{fn}=tmpwindowpoints;mapwallpoints{fn}=tmpwallpoints;
%     %for exact visibility inference
%     [ tmpwalls,tmpwallcorners,tmpwindows,tmpdoors,tmpdooredges,tmpwindowedges,tmpdoorpoints,tmpwindowpoints,tmpwallpoints ] = transfer_lable_cors( frontalwalls_all{fn},wallcorners_all{fn},windows_all{fn},doors_all{fn},dooredges_all{fn},windowedges_all{fn},floorplan2map,doorpoints_all{fn},windowpoints_all{fn},wallpoints_all{fn},map,0 );
%     mapfrontalwalls{fn}=tmpwalls;
end

%-----step 4: compute camera locations
[ camera_xs,camera_ys ] = transfer_cors( location_data );

%-----step 5: compute visibility, and render
cd ..
for which=1:3
    for fn=1:floor_num
        cd ../floorplan_visibility
        [ wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility ] = cam_visibility_new( [camera_xs(which),camera_ys(which)],mapwalls{fn},mapwallcorners{fn},mapwindows{fn},mapdoors{fn},mapdooredges{fn},mapwindowedges{fn},mapdoorpoints{fn},mapwindowpoints{fn},mapwallpoints{fn},0 );
        %-----exact visibility
%         [ exact_wallcornersvisibility,exact_visiblewalls,exact_visiblewindows,exact_visibledoors ] = cam_visibility_exact( [camera_xs(which),camera_ys(which)],mapwalls{fn},mapwallcorners{fn},mapwindows{fn},mapdoors{fn},1 );
%         cd ../render_floorplan
%         [ exact_renderresult ] = render_floorplan_roof_floor_exact_visibility( [camera_xs(which),camera_ys(which),gtCH-(fn-1)*gtFH],(location_data.headings(which)-90)/180*pi,0,gtFH,gtDH,gtWB,gtWT,mapwallcorners{fn},exact_wallcornersvisibility,exact_visiblewalls,exact_visiblewindows,exact_visibledoors,1,fn,1 );
%         cd ../floorplan_visibility
        %-----
        cd ../render_floorplan
        if fn==floor_num
            [ tmprenderresult ] = render_floorplan_roof_floor( [camera_xs(which),camera_ys(which),gtCH-(fn-1)*gtFH],(location_data.headings(which)-90)/180*pi,0,gtFH,gtDH,gtWB,gtWT,mapwallcorners{fn},mapdooredges{fn},mapwindowedges{fn},mapdoorpoints{fn},mapwindowpoints{fn},mapwallpoints{fn},wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility,1,fn,0 );
        else
            [ tmprenderresult ] = render_floorplan_roof_floor( [camera_xs(which),camera_ys(which),gtCH-(fn-1)*gtFH],(location_data.headings(which)-90)/180*pi,0,gtFH,gtDH,gtWB,gtWT,mapwallcorners{fn},mapdooredges{fn},mapwindowedges{fn},mapdoorpoints{fn},mapwindowpoints{fn},mapwallpoints{fn},wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility,0,fn,0 );
        end
        renderresult{fn}=tmprenderresult;
    end
    %merge render of multiple floors
    [ allrenderresult ] = merge_renderresult_floor( renderresult );
    all_allrenderresult{which}=allrenderresult;
end

%-----step 6: compute rectified facade
cd ../homography
for which=1:3
    %compute homography with building facade orientation
    [ facade_pts ] = compute_facade_points( map_pts,floor_num,floorplan_pts,wallcorners_all );
    [ projectedhomography ] = compute_homography( [camera_xs(which),camera_ys(which),gtCH],(location_data.headings(which)-90)/180*pi,0,homography_bot,homography_top,horizontal_expand,facade_pts,all_img_data{which},focal_len,0 );
    all_projectedhomography{which}=projectedhomography;
    [ transformed_image,tform ] = do_homography( all_img_data{which},projectedhomography,facade_pts,homography_bot,homography_top,horizontal_expand,homography_upsample_rate,0 );
    all_transformed_image{which}=transformed_image;
    all_tform{which}=tform;
    all_H{which}=(tform.tdata.T)';
end

%-----step 7: compute overall homography
cd ../render_floorplan
for which=1:3
    %compute camera extrinsic
    [ cam_R,cam_t ] = get_Rt( [camera_xs(which),camera_ys(which),gtCH],(location_data.headings(which)-90)/180*pi,0 );
    all_cam_R{which}=cam_R;
    all_cam_t{which}=cam_t;
    %compute map-to-homography transform
    K=[focal_len,0,size(all_img_data{which},2)/2;0,focal_len,size(all_img_data{which},1)/2;0,0,1;];
    all_trans_R{which}=all_H{which}*K*all_cam_R{which};
    all_trans_T{which}=all_H{which}*K*all_cam_t{which};
end

%-----step 8:apply homography to rendered floorplan, transfer to line/rect
cd ../homography
for which=1:3
    [ renderresult_homography,renderresult_homography_3D ] = homography_for_rendered_3D_floor( all_H{which},K,all_allrenderresult{which},all_transformed_image{which},0 );
    [ renderlinerects_homography,renderlinerects_homography_3D ] = get_lines_rects_floor( renderresult_homography,renderresult_homography_3D,all_transformed_image{which},display );
    all_renderlinerects_homography{which}=renderlinerects_homography;
    all_renderlinerects_homography_3D{which}=renderlinerects_homography_3D;
end

%-----step 9: compute gradient in homogeneous coordinates
ang=atan2(map_pts(2,2)-map_pts(1,2),map_pts(2,1)-map_pts(1,1));
xunit=[cos(ang);sin(ang);0;];
yunit=[cos(ang+pi/2);sin(ang+pi/2);0];
zunit=[0;0;1];
for which=1:3
    all_xgrad{which}=all_trans_R{which}*xunit;
    all_ygrad{which}=all_trans_R{which}*yunit;
    all_zgrad{which}=all_trans_R{which}*zunit;
end

%-----step 10: load building shape parameters, using 6-fold train-test
cd ../determine_dimensions
load('houseidlist.mat');
findhouse=find(houseidlist==houseid);
findhouse=findhouse(1);
testfold=mod(findhouse,6);
load(['dimensions_testfold',int2str(testfold),'.mat']);

%-----step 11: enumerate relative deformations
cd ../homography
[ all_building_deformations ] = enumerate_solution_relative_init( xrange,yrange,CH_centers,FH_centers,DH_centers,WB_centers,WT_centers,gtCH,gtFH,gtDH,gtWB,gtWT,gtXY );

%-----step 12: apply deformation
for which=1:3
    [ renderlinerects_homography_batched ] = apply_deformation_grad( all_renderlinerects_homography_3D{which},all_building_deformations,all_xgrad{which},all_ygrad{which},all_zgrad{which} );
    all_renderlinerects_homography_batched{which}=renderlinerects_homography_batched;
end

%-----extra step 13.1: sample foreground and background patches
for which=1:3
    [ projectedhomography_foreground_background ] = compute_homography_foreground_background( [camera_xs(which),camera_ys(which),gtCH],(location_data.headings(which)-90)/180*pi,0,homography_bot,homography_top,horizontal_expand,0.8,0.7,0.5,0.5,facade_pts,all_img_data{which},focal_len,0 );
    [ transformed_image_foreground_background ] = do_homography_foreground_background( all_img_data{which},projectedhomography_foreground_background,facade_pts,homography_bot,homography_top,horizontal_expand,0.7,0.7,1,1,homography_upsample_rate,0 );
    all_transformed_image_foreground_background{which}=transformed_image_foreground_background;
end
%-----extra step 13.2: compute foreground probability map with ann/gmm
cd ../ann_color
for which=1:3
    [ knnobj ] = compute_ann( all_transformed_image_foreground_background{which},0 );
    [ foreground_prob_image ] = compute_foreground_prob( all_transformed_image{which},knnobj,0,0 );
    all_foreground_prob_rgb{which}=foreground_prob_image;
    [ knnobj ] = compute_ann( all_transformed_image_foreground_background{which},1 );
    [ foreground_prob_image ] = compute_foreground_prob( all_transformed_image{which},knnobj,1,0 );
    all_foreground_prob_hsv{which}=foreground_prob_image;
end

%-----step 14: compute loss
cd ../loss_functions
for which=1:3
    if goodimages(which)==1
        [ wallloss,windowloss,doorloss,label ] = Area_of_Collision_loss_allenum( all_renderlinerects_homography_batched{which},all_building_deformations );
        all_wallloss{which}=wallloss;
        all_windowloss{which}=windowloss;
        all_doorloss{which}=doorloss;
    else
        all_wallloss{which}=zeros(size(all_building_deformations,1),1);
        all_windowloss{which}=zeros(size(all_building_deformations,1),1);
        all_doorloss{which}=zeros(size(all_building_deformations,1),1);
    end
end


% cd back to original folder
cd ../efficient_render_and_feature
end