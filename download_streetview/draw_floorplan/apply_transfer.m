function [ newpts ] = apply_transfer( floorplan2map,oldpts )
if size(oldpts,1)>0
    pts=oldpts;
    pts=pts-repmat(floorplan2map.t1,size(pts,1),1);
    pts=(floorplan2map.r*(pts'))';
    pts=pts*floorplan2map.s;
    pts=pts+repmat(floorplan2map.t2,size(pts,1),1);
    newpts=pts;
else
    newpts=[];
end
end