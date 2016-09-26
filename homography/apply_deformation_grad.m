function [ renderlinerects_homography_batched ] = apply_deformation_grad( renderlinerects_homography_3D,all_building_deformations,xgrad,ygrad,zgrad )
if size(renderlinerects_homography_3D.wallhori,1)>0
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.wallhori(:,1:3),renderlinerects_homography_3D.wallhorifn(:,1),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.wallhori(1:size(outpoints2d,1),1:2)=round(outpoints2d);
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.wallhori(:,4:6),renderlinerects_homography_3D.wallhorifn(:,2),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.wallhori(1:size(outpoints2d,1),3:4)=round(outpoints2d);
else
    renderlinerects_homography_batched.wallhori=[];
end

if size(renderlinerects_homography_3D.wallvert,1)>0
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.wallvert(:,1:3),renderlinerects_homography_3D.wallvertfn(:,1),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.wallvert(1:size(outpoints2d,1),1:2)=round(outpoints2d);
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.wallvert(:,4:6),renderlinerects_homography_3D.wallvertfn(:,2),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.wallvert(1:size(outpoints2d,1),3:4)=round(outpoints2d);
else
    renderlinerects_homography_batched.wallvert=[];
end

if size(renderlinerects_homography_3D.door,1)>0
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.door(:,1:3),renderlinerects_homography_3D.doorfn(:,1),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3)+all_building_deformations(:,5),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.door(1:size(outpoints2d,1),1:2)=round(outpoints2d);
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.door(:,4:6),renderlinerects_homography_3D.doorfn(:,2),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.door(1:size(outpoints2d,1),3:4)=round(outpoints2d);
else
    renderlinerects_homography_batched.door=[];
end

if size(renderlinerects_homography_3D.window,1)>0
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.window(:,1:3),renderlinerects_homography_3D.windowfn(:,1),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3)+all_building_deformations(:,7),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.window(1:size(outpoints2d,1),1:2)=round(outpoints2d);
    [ outpoints2d ] = apply_deformation_grad_1type( renderlinerects_homography_3D.window(:,4:6),renderlinerects_homography_3D.windowfn(:,2),all_building_deformations(:,1),all_building_deformations(:,2),-all_building_deformations(:,3)+all_building_deformations(:,6),all_building_deformations(:,4),xgrad,ygrad,zgrad );
    renderlinerects_homography_batched.window(1:size(outpoints2d,1),3:4)=round(outpoints2d);
else
    renderlinerects_homography_batched.window=[];
end
end