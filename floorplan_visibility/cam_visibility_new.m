function [ wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility ] = cam_visibility_new( camposition,walls,wallcorners,windows,doors,dooredges,windowedges,doorpoints,windowpoints,wallpoints,display )
alllines=[walls;windows;doors];
%corner visibility
[ wallcornersvisibility ] = point_visibility_new( alllines,wallcorners,camposition );

%door edge visibility
if size(dooredges,1)>0
    [ dooredgesvisibility ] = point_visibility_new( alllines,dooredges,camposition );
else
    dooredgesvisibility=[];
end

%window edge visibility
if size(windowedges,1)>0
    [ windowedgesvisibility ] = point_visibility_new( alllines,windowedges,camposition );
else
    windowedgesvisibility=[];
end

%point visibility
[ wallpointvisibility ] = point_visibility_new( alllines,wallpoints,camposition );
if size(doorpoints,1)>0
    [ doorpointvisibility ] = point_visibility_new( alllines,doorpoints,camposition );
else
    doorpointvisibility=[];
end
if size(windowpoints,1)>0
    [ windowpointvisibility ] = point_visibility_new( alllines,windowpoints,camposition );
else
    windowpointvisibility=[];
end
%[ wallpointvisibility ] = point_visibility_via_img( camposition,wallpoints,insideimg );
%[ doorpointvisibility ] = point_visibility_via_img( camposition,doorpoints,insideimg );
%[ windowpointvisibility ] = point_visibility_via_img( camposition,windowpoints,insideimg );

if display==1
    figure;
    hold on;
    plot(camposition(1),-camposition(2),'k.','MarkerSize',25);
    viswallcorners=wallcorners(wallcornersvisibility,:);
    visdooredges=dooredges(dooredgesvisibility,:);
    viswindowedges=windowedges(windowedgesvisibility,:);
    viswallpts=wallpoints(wallpointvisibility,:);
    visdoorpts=doorpoints(doorpointvisibility,:);
    viswindowpts=windowpoints(windowpointvisibility,:);
    plot(viswallpts(:,1),-viswallpts(:,2),'r.');
    if size(visdoorpts,1)>0
        plot(visdoorpts(:,1),-visdoorpts(:,2),'b.');
    end
    if size(viswindowpts,1)>0
        plot(viswindowpts(:,1),-viswindowpts(:,2),'g.');
    end
    if size(viswallcorners,1)>0
        plot(viswallcorners(:,1),-viswallcorners(:,2),'y.','MarkerSize',25);
    end
    if size(visdooredges,1)>0
        plot(visdooredges(:,1),-visdooredges(:,2),'b.','MarkerSize',25);
    end
    if size(viswindowedges,1)>0
        plot(viswindowedges(:,1),-viswindowedges(:,2),'g.','MarkerSize',25);
    end
    axis equal;
    hold off;
end
