function [ mapwalls,mapwallcorners,mapwindows,mapdoors,mapdooredges,mapwindowedges,mapdoorpoints,mapwindowpoints,mapwallpoints ] = transfer_lable_cors( walls,wallcorners,windows,doors,dooredges,windowedges,floorplan2map,doorpoints,windowpoints,wallpoints,map,display )
[ mapwalls ] = apply_transfer2( floorplan2map,walls );
[ mapwallcorners ] = apply_transfer( floorplan2map,wallcorners );
[ mapwindows ] = apply_transfer2( floorplan2map,windows );
[ mapdoors ] = apply_transfer2( floorplan2map,doors );
[ mapdooredges ] = apply_transfer( floorplan2map,dooredges );
[ mapwindowedges ] = apply_transfer( floorplan2map,windowedges );
[ mapdoorpoints ] = apply_transfer( floorplan2map,doorpoints );
[ mapwindowpoints ] = apply_transfer( floorplan2map,windowpoints );
[ mapwallpoints ] = apply_transfer( floorplan2map,wallpoints );

if display==1
    figure
    imshow(map);
    hold on;
    if size(mapdoorpoints,1)>0
        plot(mapdoorpoints(:,1),mapdoorpoints(:,2),'b.');
    end
    if size(mapwindowpoints,1)>0
        plot(mapwindowpoints(:,1),mapwindowpoints(:,2),'g.');
    end
    plot(mapwallpoints(:,1),mapwallpoints(:,2),'r.');
    hold off;
end
end