function [ R,t ] = get_Rt( camxyz,orientation,tilt )
m1=[0,1,0;1,0,0;0,0,1;];
m2=[1,0,0;0,0,-1;0,1,0;];
dcm1=angle2dcm(0,orientation,0);
dcm2=angle2dcm(0,0,tilt);
R=dcm2*dcm1*m2*m1;
t=R*(-camxyz');
end