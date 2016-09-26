function [ exact_renderresult ] = render_floorplan_roof_floor_exact_visibility( camxyz,orientation,tilt,wallheight,doorheight,windowbot,windowtop,wallcorners,wallcornersvisibility,visiblewalls,visiblewindows,visibledoors,roofornoroof,nowfn,display )
%walls
if size(visiblewalls,1)>0
    walllines=[];
    [ tmp1 ] = transform_3d( [visiblewalls(:,1:2),ones(size(visiblewalls,1),1)*0],camxyz,orientation,tilt );
    [ tmp2 ] = transform_3d( [visiblewalls(:,3:4),ones(size(visiblewalls,1),1)*0],camxyz,orientation,tilt );
    walllines=[tmp1,tmp2];
    walllinesfn=ones(size(visiblewalls,1),1)*(nowfn-1);
    if roofornoroof==1
        %disp('has roof!')
        [ tmp1 ] = transform_3d( [visiblewalls(:,1:2),ones(size(visiblewalls,1),1)*wallheight],camxyz,orientation,tilt );
        [ tmp2 ] = transform_3d( [visiblewalls(:,3:4),ones(size(visiblewalls,1),1)*wallheight],camxyz,orientation,tilt );
        tmpfn=ones(size(visiblewalls,1),1)*nowfn;
        walllines=[walllines;tmp1,tmp2;];
        walllinesfn=[walllinesfn;tmpfn;];
    end
else
    walllines=[];
    walllinesfn=[];
end
if sum(wallcornersvisibility>0)
    wallcornerlines=[];
    renderwallcorners=wallcorners(wallcornersvisibility,:);
    minh=0;maxh=wallheight;
    [ tmp1 ] = transform_3d( [renderwallcorners,ones(size(renderwallcorners,1),1)*minh],camxyz,orientation,tilt );
    [ tmp2 ] = transform_3d( [renderwallcorners,ones(size(renderwallcorners,1),1)*maxh],camxyz,orientation,tilt );
    wallcornerlines=[tmp1,tmp2];
    wallcornerlinessfn=[ones(size(renderwallcorners,1),1)*(nowfn-1),ones(size(renderwallcorners,1),1)*(nowfn)];
else
    wallcornerlines=[];
    wallcornerlinessfn=[];
end

%windows
if size(visiblewindows,1)>0
    renderwindowrects=[];
    [ tmp1 ] = transform_3d( [visiblewindows(:,1:2),ones(size(visiblewindows,1),1)*windowtop],camxyz,orientation,tilt );
    [ tmp2 ] = transform_3d( [visiblewindows(:,3:4),ones(size(visiblewindows,1),1)*windowtop],camxyz,orientation,tilt );
    [ tmp3 ] = transform_3d( [visiblewindows(:,3:4),ones(size(visiblewindows,1),1)*windowbot],camxyz,orientation,tilt );
    [ tmp4 ] = transform_3d( [visiblewindows(:,1:2),ones(size(visiblewindows,1),1)*windowbot],camxyz,orientation,tilt );
    renderwindowrects=[tmp1,tmp2,tmp3,tmp4];
    windowrectsfn=ones(size(visiblewindows,1),1)*(nowfn-1);
else
    renderwindowrects=[];
    windowrectsfn=[];
end

%doors
if size(visibledoors,1)>0
    renderdoorrects=[];
    [ tmp1 ] = transform_3d( [visibledoors(:,1:2),ones(size(visibledoors,1),1)*doorheight],camxyz,orientation,tilt );
    [ tmp2 ] = transform_3d( [visibledoors(:,3:4),ones(size(visibledoors,1),1)*doorheight],camxyz,orientation,tilt );
    [ tmp3 ] = transform_3d( [visibledoors(:,3:4),ones(size(visibledoors,1),1)*0],camxyz,orientation,tilt );
    [ tmp4 ] = transform_3d( [visibledoors(:,1:2),ones(size(visibledoors,1),1)*0],camxyz,orientation,tilt );
    renderdoorrects=[tmp1,tmp2,tmp3,tmp4];
    doorrectsfn=ones(size(visiblewindows,1),1)*(nowfn-1);
else
    renderdoorrects=[];
    doorrectsfn=[];
end

exact_renderresult.walllines=walllines;
exact_renderresult.wallcornerlines=wallcornerlines;
exact_renderresult.renderwindowrects=renderwindowrects;
exact_renderresult.renderdoorrects=renderdoorrects;

exact_renderresult.walllinesfn=walllinesfn;
exact_renderresult.wallcornerlinessfn=wallcornerlinessfn;
exact_renderresult.windowrectsfn=windowrectsfn;
exact_renderresult.doorrectsfn=doorrectsfn;

if display==1
    figure;
    hold on;
    for ii=1:size(walllines,1)
        plot([walllines(ii,1)./walllines(ii,3);walllines(ii,4)./walllines(ii,6)],-[walllines(ii,2)./walllines(ii,3);walllines(ii,5)./walllines(ii,6)],'r*-');
    end
    for ii=1:size(wallcornerlines,1)
        plot([wallcornerlines(ii,1)./wallcornerlines(ii,3);wallcornerlines(ii,4)./wallcornerlines(ii,6)],-[wallcornerlines(ii,2)./wallcornerlines(ii,3);wallcornerlines(ii,5)./wallcornerlines(ii,6)],'y*-');
    end
    for ii=1:size(renderwindowrects,1)
        plot([renderwindowrects(ii,1)./renderwindowrects(ii,3);renderwindowrects(ii,4)./renderwindowrects(ii,6);renderwindowrects(ii,7)./renderwindowrects(ii,9);renderwindowrects(ii,10)./renderwindowrects(ii,12);renderwindowrects(ii,1)./renderwindowrects(ii,3);],-[renderwindowrects(ii,2)./renderwindowrects(ii,3);renderwindowrects(ii,5)./renderwindowrects(ii,6);renderwindowrects(ii,8)./renderwindowrects(ii,9);renderwindowrects(ii,11)./renderwindowrects(ii,12);renderwindowrects(ii,2)./renderwindowrects(ii,3);],'g*-');
    end
    for ii=1:size(renderdoorrects,1)
        plot([renderdoorrects(ii,1)./renderdoorrects(ii,3);renderdoorrects(ii,4)./renderdoorrects(ii,6);renderdoorrects(ii,7)./renderdoorrects(ii,9);renderdoorrects(ii,10)./renderdoorrects(ii,12);renderdoorrects(ii,1)./renderdoorrects(ii,3);],-[renderdoorrects(ii,2)./renderdoorrects(ii,3);renderdoorrects(ii,5)./renderdoorrects(ii,6);renderdoorrects(ii,8)./renderdoorrects(ii,9);renderdoorrects(ii,11)./renderdoorrects(ii,12);renderdoorrects(ii,2)./renderdoorrects(ii,3);],'b*-');
    end
    axis equal
    hold off;
end
