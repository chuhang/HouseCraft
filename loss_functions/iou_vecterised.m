function [ overlapArea ] = iou_vecterised( gts,prs )
intersectionArea=myrectint(gts,prs);
x_g=gts(:,1);y_g=gts(:,2);w_g=gts(:,3);h_g=gts(:,4);
x_p=prs(:,1);y_p=prs(:,2);w_p=prs(:,3);h_p=prs(:,4);
unionCoords=[min([x_g,x_p]')',min([y_g,y_p]')',max([x_g+w_g-1,x_p+w_p-1]')',max([y_g+h_g-1,y_p+h_p-1]')'];
unionArea=(unionCoords(:,3)-unionCoords(:,1)+1).*(unionCoords(:,4)-unionCoords(:,2)+1);
overlapArea=intersectionArea./unionArea;
end