function [ transformed_image_foreground_background ] = do_homography_foreground_background( img_data,projectedhomography_foreground_background,map_pts,homography_bot,homography_top,horizontal_expand,inner_ratio_vert,inner_ratio_hori,outer_ratio_vert,outer_ratio_hori,upsample_rate,display )
w=round(sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2))*horizontal_expand*upsample_rate*inner_ratio_hori);
h=round((homography_top-homography_bot)*upsample_rate*inner_ratio_vert);
tform=cp2tform(projectedhomography_foreground_background.foreground,[1,h;w,h;1,1;w,1;],'projective');
transformed_image_foreground=imtransform(img_data,tform,'XData',[1,w],'YData',[1,h]);

w=round(sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2))*upsample_rate*outer_ratio_hori);
h=round((homography_top-homography_bot)*upsample_rate);
tform=cp2tform(projectedhomography_foreground_background.background1,[1,h;w,h;1,1;w,1;],'projective');
transformed_image_background1=imtransform(img_data,tform,'XData',[1,w],'YData',[1,h]);

w=round(sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2))*upsample_rate*outer_ratio_hori);
h=round((homography_top-homography_bot)*upsample_rate);
tform=cp2tform(projectedhomography_foreground_background.background2,[1,h;w,h;1,1;w,1;],'projective');
transformed_image_background2=imtransform(img_data,tform,'XData',[1,w],'YData',[1,h]);

w=round(sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2))*upsample_rate*horizontal_expand);
h=round(homography_top*upsample_rate*outer_ratio_vert);
tform=cp2tform(projectedhomography_foreground_background.background3,[1,h;w,h;1,1;w,1;],'projective');
transformed_image_background3=imtransform(img_data,tform,'XData',[1,w],'YData',[1,h]);

w=round(sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2))*upsample_rate*horizontal_expand);
h=round(-homography_bot*upsample_rate*outer_ratio_vert);
tform=cp2tform(projectedhomography_foreground_background.background4,[1,h;w,h;1,1;w,1;],'projective');
transformed_image_background4=imtransform(img_data,tform,'XData',[1,w],'YData',[1,h]);

transformed_image_foreground_background.foreground=transformed_image_foreground;
transformed_image_foreground_background.background1=transformed_image_background1;
transformed_image_foreground_background.background2=transformed_image_background2;
transformed_image_foreground_background.background3=transformed_image_background3;
transformed_image_foreground_background.background4=transformed_image_background4;

if display==1
    figure;
    subplot(3,3,2);
    imshow(transformed_image_background3);
    subplot(3,3,4);
    imshow(transformed_image_background1);
    subplot(3,3,5);
    imshow(transformed_image_foreground);
    subplot(3,3,6);
    imshow(transformed_image_background2);
    subplot(3,3,8);
    imshow(transformed_image_background4);
end
end