function [ renderlinerects_homography,renderlinerects_homography_3D ] = get_lines_rects_floor( renderresult_homography,renderresult_homography_3D,transformed_image,display )
canvas_img=uint8(zeros(size(transformed_image,1),size(transformed_image,2),3));
if size(renderresult_homography.wallpoints,1)>0
    canvas_img=plot_on_img(canvas_img,renderresult_homography.wallpoints(:,1),renderresult_homography.wallpoints(:,2),'g');
end
[ wallhorilines ] = figure_line_segments( canvas_img,0 );

canvas_img=uint8(zeros(size(transformed_image,1),size(transformed_image,2),3));
if size(renderresult_homography.wallcorners,1)>0
    canvas_img=plot_on_img(canvas_img,renderresult_homography.wallcorners(:,1),renderresult_homography.wallcorners(:,2),'g');
end
[ wallvertlines ] = figure_line_segments( canvas_img,1 );

canvas_img=uint8(zeros(size(transformed_image,1),size(transformed_image,2),3));
if size(renderresult_homography.doorpoints1,1)>0
    canvas_img=plot_on_img(canvas_img,renderresult_homography.doorpoints1(:,1),renderresult_homography.doorpoints1(:,2),'g');
end
if size(renderresult_homography.doorpoints2,1)>0
    canvas_img=plot_on_img(canvas_img,renderresult_homography.doorpoints2(:,1),renderresult_homography.doorpoints2(:,2),'g');
end
[ tmphorilines ] = figure_line_segments( canvas_img,0 );
[ doorrects ] = figure_rects_from_lines( tmphorilines );

canvas_img=uint8(zeros(size(transformed_image,1),size(transformed_image,2),3));
if size(renderresult_homography.windowpoints2,1)>0
    canvas_img=plot_on_img(canvas_img,renderresult_homography.windowpoints2(:,1),renderresult_homography.windowpoints2(:,2),'g');
end
if size(renderresult_homography.windowpoints3,1)>0
    canvas_img=plot_on_img(canvas_img,renderresult_homography.windowpoints3(:,1),renderresult_homography.windowpoints3(:,2),'g');
end
[ tmphorilines ] = figure_line_segments( canvas_img,0 );
[ windowrects ] = figure_rects_from_lines( tmphorilines );

if size(wallhorilines,1)>0
    [ outpoints2d,outpoints3d,outfns ] = find_nearest_points_floor( wallhorilines,renderresult_homography.wallpoints,renderresult_homography_3D.wallpoints,renderresult_homography.wallpointsfn );
    renderlinerects_homography.wallhori=outpoints2d;
    renderlinerects_homography_3D.wallhori=outpoints3d;
    renderlinerects_homography.wallhorifn=outfns;
    renderlinerects_homography_3D.wallhorifn=outfns;
else
    renderlinerects_homography.wallhori=[];
    renderlinerects_homography_3D.wallhori=[];
    renderlinerects_homography.wallhorifn=[];
    renderlinerects_homography_3D.wallhorifn=[];
end
if size(wallvertlines,1)>0
    [ outpoints2d,outpoints3d,outfns ] = find_nearest_points_floor( wallvertlines,renderresult_homography.wallcorners,renderresult_homography_3D.wallcorners,renderresult_homography.wallcornersfn );
    renderlinerects_homography.wallvert=outpoints2d;
    renderlinerects_homography_3D.wallvert=outpoints3d;
    renderlinerects_homography.wallvertfn=outfns;
    renderlinerects_homography_3D.wallvertfn=outfns;
else
    renderlinerects_homography.wallvert=[];
    renderlinerects_homography_3D.wallvert=[];
    renderlinerects_homography.wallvertfn=[];
    renderlinerects_homography_3D.wallvertfn=[];
end
if size(doorrects,1)>0
    [ outpoints2d,outpoints3d,outfns ] = find_nearest_points_floor( doorrects,[renderresult_homography.doorpoints1;renderresult_homography.doorpoints2;],[renderresult_homography_3D.doorpoints1;renderresult_homography_3D.doorpoints2;],[renderresult_homography.doorpointsfn;renderresult_homography.doorpointsfn;] );
    renderlinerects_homography.door=outpoints2d;
    renderlinerects_homography_3D.door=outpoints3d;
    renderlinerects_homography.doorfn=outfns;
    renderlinerects_homography_3D.doorfn=outfns;
else
    renderlinerects_homography.door=[];
    renderlinerects_homography_3D.door=[];
    renderlinerects_homography.doorfn=[];
    renderlinerects_homography_3D.doorfn=[];
end
if size(windowrects,1)>0
    [ outpoints2d,outpoints3d,outfns ] = find_nearest_points_floor( windowrects,[renderresult_homography.windowpoints2;renderresult_homography.windowpoints3;],[renderresult_homography_3D.windowpoints2;renderresult_homography_3D.windowpoints3;],[renderresult_homography.windowpointsfn;renderresult_homography.windowpointsfn;] );
    renderlinerects_homography.window=outpoints2d;
    renderlinerects_homography_3D.window=outpoints3d;
    renderlinerects_homography.windowfn=outfns;
    renderlinerects_homography_3D.windowfn=outfns;
else
    renderlinerects_homography.window=[];
    renderlinerects_homography_3D.window=[];
    renderlinerects_homography.windowfn=[];
    renderlinerects_homography_3D.windowfn=[];
end

if display==1
    figure;
    imshow(transformed_image);
    hold on;
    for ii=1:size(renderlinerects_homography.wallhori,1)
        plot([renderlinerects_homography.wallhori(ii,1);renderlinerects_homography.wallhori(ii,3);],[renderlinerects_homography.wallhori(ii,2);renderlinerects_homography.wallhori(ii,4);],'r-*');
    end
    for ii=1:size(renderlinerects_homography.wallvert,1)
        plot([renderlinerects_homography.wallvert(ii,1);renderlinerects_homography.wallvert(ii,3);],[renderlinerects_homography.wallvert(ii,2);renderlinerects_homography.wallvert(ii,4);],'y-*');
    end
    for ii=1:size(renderlinerects_homography.door,1)
        plot([renderlinerects_homography.door(ii,1);renderlinerects_homography.door(ii,3);renderlinerects_homography.door(ii,3);renderlinerects_homography.door(ii,1);renderlinerects_homography.door(ii,1);],[renderlinerects_homography.door(ii,2);renderlinerects_homography.door(ii,2);renderlinerects_homography.door(ii,4);renderlinerects_homography.door(ii,4);renderlinerects_homography.door(ii,2);],'b-*');
    end
    for ii=1:size(renderlinerects_homography.window,1)
        plot([renderlinerects_homography.window(ii,1);renderlinerects_homography.window(ii,3);renderlinerects_homography.window(ii,3);renderlinerects_homography.window(ii,1);renderlinerects_homography.window(ii,1);],[renderlinerects_homography.window(ii,2);renderlinerects_homography.window(ii,2);renderlinerects_homography.window(ii,4);renderlinerects_homography.window(ii,4);renderlinerects_homography.window(ii,2);],'g-*');
    end
    hold off;
end
end