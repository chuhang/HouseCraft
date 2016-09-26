function [ isvisible ] = point_visibility_new( alllines,points,camposition )
cornerraypt1=repmat(camposition,size(points,1),1);
cornerraypt2=points;

intersectout=lineSegmentIntersect([cornerraypt1,cornerraypt2],alllines);
isintersect=intersectout.intAdjacencyMatrix;
intersectX=intersectout.intMatrixX;
intersectY=intersectout.intMatrixY;
for ii=1:size(isintersect,1)
    for jj=1:size(isintersect,2)
        if isintersect(ii,jj)
            dis0=sqrt(sum((cornerraypt2(ii,1:2)-[intersectX(ii,jj),intersectY(ii,jj)]).^2));
            dis1=sqrt(sum((cornerraypt2(ii,1:2)-alllines(jj,1:2)).^2));
            dis2=sqrt(sum((cornerraypt2(ii,1:2)-alllines(jj,3:4)).^2));
            if min([dis0,dis1,dis2])<0.1
                isintersect(ii,jj)=0;
            end
        end
    end
end
isvisible=(sum(isintersect,2)==0);
end

