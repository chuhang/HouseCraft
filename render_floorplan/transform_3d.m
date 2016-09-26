function [ newpoints ] = transform_3d( points,camxyz,orientation,tilt )
newpoints=points-repmat(camxyz,size(points,1),1);
newpoints=[newpoints(:,2),newpoints(:,1),newpoints(:,3)];
newpoints=[newpoints(:,1),-newpoints(:,3),newpoints(:,2)];
dcm=angle2dcm(0,orientation,0);
newpoints=(dcm*newpoints')';
dcm=angle2dcm(0,0,tilt);
newpoints=(dcm*newpoints')';
end