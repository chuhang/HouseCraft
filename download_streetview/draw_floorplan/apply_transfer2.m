function [ newpts ] = apply_transfer2( floorplan2map,oldpts )
if size(oldpts,1)>0
    pts=oldpts(:,1:2);
    pts=pts-repmat(floorplan2map.t1,size(pts,1),1);
    pts=(floorplan2map.r*(pts'))';
    pts=pts*floorplan2map.s;
    pts=pts+repmat(floorplan2map.t2,size(pts,1),1);
    result1=pts;

    pts=oldpts(:,3:4);
    pts=pts-repmat(floorplan2map.t1,size(pts,1),1);
    pts=(floorplan2map.r*(pts'))';
    pts=pts*floorplan2map.s;
    pts=pts+repmat(floorplan2map.t2,size(pts,1),1);
    result2=pts;

    newpts=[result1,result2];
else
    newpts=[];
end
end