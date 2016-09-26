function [ transformed_image,tform ] = do_homography( img_data,projectedhomography,map_pts,homography_bot,homography_top,horizontal_expand,upsample_rate,display )
w=round(sqrt(sum((map_pts(1,:)-map_pts(2,:)).^2))*horizontal_expand*upsample_rate);
h=round((homography_top-homography_bot)*upsample_rate);
tform=cp2tform(projectedhomography,[1,h;w,h;1,1;w,1;],'projective');
transformed_image=imtransform(img_data,tform,'XData',[1,w],'YData',[1,h]);

if display==1
    figure;
    imshow(transformed_image);
end
end