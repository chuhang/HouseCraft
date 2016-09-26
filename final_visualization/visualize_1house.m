function [ renderresult,all_viswalls,all_viswindows,all_visdoors,result,all_img_data,camera_xs,camera_ys,all_walls_novis,all_windows_novis,all_doors_novis ] = visualize_1house( houseid,result,docombine,display )
%loading result
cd ../determine_dimensions
load('houseidlist.mat');
tmp=find(houseidlist==houseid);
tmp=tmp(1);

cd ../efficient_render_and_feature
%-----load data, specify parameters
cd(['../rent_crawler/goodhouses/house',int2str(houseid)]);
load('floorplan_label_data.mat');
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

%-----step1: shifting center to GT
cd ../../../prepare_WebGL
[ map_pts ] = refine_map_pts( map_pts,floorplan_pts,pixel2m );
ang=atan2(map_pts(2,2)-map_pts(1,2),map_pts(2,1)-map_pts(1,1));
xtmp=[cos(ang),sin(ang)];
ytmp=[cos(ang+pi/2),sin(ang+pi/2)];
map_pts(1,:)=map_pts(1,:)+result(1)*xtmp+result(2)*ytmp;
map_pts(2,:)=map_pts(2,:)+result(1)*xtmp+result(2)*ytmp;

%-----step 2: read floorplan labels
cd ../proc_floorplan_label
for fn=1:floor_num
    [ walls,wallcorners,windows,doors,dooredges,windowedges,imgsize ] = proc_floorplan_label( ['../rent_crawler/goodhouses/house',int2str(datanum),'/floorplan_label',int2str(fn),'.png'],0 );
    %[ frontalwalls ] = get_frontal_facade( walls,windows,doors,floorplan_pts{fn},0 );
    [ doorpoints,windowpoints,wallpoints ] = pointalize_floorplan_scale( doors,windows,walls,pixel2m,0 );
    walls_all{fn}=walls;wallcorners_all{fn}=wallcorners;windows_all{fn}=windows;doors_all{fn}=doors;dooredges_all{fn}=dooredges;windowedges_all{fn}=windowedges;imgsize_all{fn}=imgsize;
    doorpoints_all{fn}=doorpoints;windowpoints_all{fn}=windowpoints;wallpoints_all{fn}=wallpoints;
end

%-----step 3: transfer to map coordinate
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
all_walls_novis=mapwalls;
all_windows_novis=mapwindows;
all_doors_novis=mapdoors;

%-----step 4: compute camera locations
[ camera_xs,camera_ys ] = transfer_cors( location_data );

%-----step 5: compute visibility, and render
if docombine==1
    cd ..
    for which=1:3
        for fn=1:floor_num
            cd ../floorplan_visibility
            %[ wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility ] = cam_visibility_new( [camera_xs(which),camera_ys(which)],mapwalls{fn},mapwallcorners{fn},mapwindows{fn},mapdoors{fn},mapdooredges{fn},mapwindowedges{fn},mapdoorpoints{fn},mapwindowpoints{fn},mapwallpoints{fn},0 );
            %-----exact visibility
            [ exact_wallcornersvisibility,exact_visiblewalls,exact_visiblewindows,exact_visibledoors ] = cam_visibility_exact( [camera_xs(which),camera_ys(which)],mapwalls{fn},mapwallcorners{fn},mapwindows{fn},mapdoors{fn},0 );
            cd ../render_floorplan
            [ exact_renderresult ] = render_floorplan_roof_floor_exact_visibility( [camera_xs(which),camera_ys(which),result(3)-(fn-1)*result(4)],(location_data.headings(which)-90)/180*pi,0,result(4),result(5),result(6),result(7),mapwallcorners{fn},exact_wallcornersvisibility,exact_visiblewalls,exact_visiblewindows,exact_visibledoors,1,fn,0 );
            [ onimgresult ] = visualize_onimg( exact_renderresult,all_img_data{which},0 );
            tmpformerge{fn}=onimgresult;
            cd ../floorplan_visibility
            %-----        
        end
        cd ../render_floorplan
        [ allrenderresult ] = merge_on_img_render( tmpformerge,all_img_data{which},display );
        renderresult{which}=allrenderresult;
        all_viswalls{which}=exact_visiblewalls;
        all_viswindows{which}=exact_visiblewindows;
        all_visdoors{which}=exact_visibledoors;
    end
else
    cd ..
    for which=1:3
        for fn=1:floor_num
            cd ../floorplan_visibility
            %[ wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility ] = cam_visibility_new( [camera_xs(which),camera_ys(which)],mapwalls{fn},mapwallcorners{fn},mapwindows{fn},mapdoors{fn},mapdooredges{fn},mapwindowedges{fn},mapdoorpoints{fn},mapwindowpoints{fn},mapwallpoints{fn},0 );
            %-----exact visibility
            [ exact_wallcornersvisibility,exact_visiblewalls,exact_visiblewindows,exact_visibledoors ] = cam_visibility_exact( [camera_xs(which),camera_ys(which)],mapwalls{fn},mapwallcorners{fn},mapwindows{fn},mapdoors{fn},0 );
            cd ../render_floorplan
            [ exact_renderresult ] = render_floorplan_roof_floor_exact_visibility( [camera_xs(which),camera_ys(which),result(3)-(fn-1)*result(4)],(location_data.headings(which)-90)/180*pi,0,result(4),result(5),result(6),result(7),mapwallcorners{fn},exact_wallcornersvisibility,exact_visiblewalls,exact_visiblewindows,exact_visibledoors,1,fn,0 );
            [ onimgresult ] = visualize_onimg( exact_renderresult,all_img_data{which},display );
            cd ../floorplan_visibility
            %-----        
            renderresult{which}{fn}=onimgresult;
            all_viswalls{which}{fn}=exact_visiblewalls;
            all_viswindows{which}{fn}=exact_visiblewindows;
            all_visdoors{which}{fn}=exact_visibledoors;
        end
    end
end

% cd back to original folder
cd ../final_visualization
end