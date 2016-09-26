function [ area ] = myrectint( a,b )
%modified from Octave rectint
area=zeros(size(a,1),1);
r1=[a(:,1:2),a(:,1:2)+a(:,3:4)];
r2=[b(:,1:2),b(:,1:2)+b(:,3:4)];
%Find the location of each point relative to the other points.
r1x1small=r1(:,1)<r2(:,1);
r1x1large=r1(:,1)>r2(:,3);
r1x1mid=((r1(:,1)>=r2(:,1))) & ((r1(:,1)<=r2(:,3)));
r1x2small=r1(:,3)<r2(:,1);
r1x2large=r1(:,3)>r2(:,3);
r1x2mid=((r1(:,3)>=r2(:,1))) & ((r1(:,3)<=r2(:,3)));

r1y1small=r1(:,2)<r2(:,2);
r1y1large=r1(:,2)>r2(:,4);
r1y1mid=((r1(:,2)>=r2(:,2))) & ((r1(:,2)<=r2(:,4)));
r1y2small=r1(:,4)<r2(:,2);
r1y2large=r1(:,4)>r2(:,4);
r1y2mid=((r1(:,4)>=r2(:,2))) & ((r1(:,4)<=r2(:,4)));

%determine the width of the rectangle
%r1 completely encloses r2
mask=r1x1small&r1x2large;
area(mask,1)=r2(mask,3)-r2(mask,1);
%the range goes from r2x min to r1x max
mask=r1x1small&r1x2mid;
area(mask,1)=r1(mask,3)-r2(mask,1);
%the range goes from r1x min to r2x max
mask=r1x1mid&r1x2large;
area(mask,1)=r2(mask,3)-r1(mask,1);
%the range goes from r1x min to r1x max
mask=r1x1mid&r1x2mid;
area(mask,1)=r1(mask,3)-r1(mask,1);

%determine the height of the rectangle
%r1 completely encloses r2
mask=r1y1small&r1y2large;
area(mask,1)=area(mask,1).*(r2(mask,4)-r2(mask,2));
%the range goes from r2y min to r1y max
mask=r1y1small&r1y2mid;
area(mask,1)=area(mask,1).*(r1(mask,4)-r2(mask,2));
%the range goes from r1y min to r2y max
mask=r1y1mid&r1y2large;
area(mask,1)=area(mask,1).*(r2(mask,4)-r1(mask,2));
%the range goes from r1x min to r1x max
mask=r1y1mid&r1y2mid;
area(mask,1)=area(mask,1).*(r1(mask,4)-r1(mask,2));
end