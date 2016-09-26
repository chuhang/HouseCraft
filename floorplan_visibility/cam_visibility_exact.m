function [ wallcornersvisibility,visiblewalls,visiblewindows,visibledoors ] = cam_visibility_exact( camposition,walls,wallcorners,windows,doors,display )
alllines=[walls;windows;doors];
%corner visibility
[ wallcornersvisibility ] = point_visibility_new( alllines,wallcorners,camposition );

%exact line visibility with type
[ visiblewalls,visiblewindows,visibledoors ] = line_visibility_exact( camposition,walls,windows,doors,0 );

if display==1
    figure;
    hold on;
    plot(camposition(1),-camposition(2),'k.','MarkerSize',25);
    viswallcorners=wallcorners(wallcornersvisibility,:);
    if size(viswallcorners,1)>0
        plot(viswallcorners(:,1),-viswallcorners(:,2),'y.','MarkerSize',25);
    end
    for ii=1:size(visiblewalls,1)
        plot([visiblewalls(ii,1);visiblewalls(ii,3)],-[visiblewalls(ii,2);visiblewalls(ii,4)],'r*-');
    end
    for ii=1:size(visiblewindows,1)
        plot([visiblewindows(ii,1);visiblewindows(ii,3)],-[visiblewindows(ii,2);visiblewindows(ii,4)],'g*-');
    end
    for ii=1:size(visibledoors,1)
        plot([visibledoors(ii,1);visibledoors(ii,3)],-[visibledoors(ii,2);visibledoors(ii,4)],'b*-');
    end
    axis equal;
    hold off;
end
