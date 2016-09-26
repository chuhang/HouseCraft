function [ renderresult ] = render_floorplan_roof_floor( camxyz,orientation,tilt,wallheight,doorheight,windowbot,windowtop,wallcorners,dooredges,windowedges,doorpoints,windowpoints,wallpoints,wallcornersvisibility,dooredgesvisibility,windowedgesvisibility,wallpointvisibility,doorpointvisibility,windowpointvisibility,roofornoroof,nowfn,display )
wallpoints=[wallpoints;doorpoints;windowpoints;];
wallpointvisibility=logical([wallpointvisibility;doorpointvisibility;windowpointvisibility;]);
%walls
if sum(wallpointvisibility)>0
    renderwallpoints=wallpoints(wallpointvisibility,:);
    renderwallpoints=[renderwallpoints,zeros(size(renderwallpoints,1),1)];
    [ renderwallpoints ] = transform_3d( renderwallpoints,camxyz,orientation,tilt );
    wallpointsfn=ones(size(renderwallpoints,1),1)*(nowfn-1);
    if roofornoroof==1
        %disp('has roof!')
        renderroofpoints=wallpoints(wallpointvisibility,:);
        renderroofpoints=[renderroofpoints,wallheight*ones(size(renderroofpoints,1),1)];
        [ roofpoints ] = transform_3d( renderroofpoints,camxyz,orientation,tilt );
        roofpointsfn=ones(size(roofpoints,1),1)*nowfn;
        renderwallpoints=[renderwallpoints;roofpoints;];
        wallpointsfn=[wallpointsfn;roofpointsfn;];
    end
else
    renderwallpoints=[];
    wallpointsfn=[];
end
if sum(wallcornersvisibility>0)
    renderwallcorners=wallcorners(wallcornersvisibility,:);
    minh=0;maxh=wallheight;
    tmp=repmat((minh:maxh),size(renderwallcorners,1),1);
    renderwallcorners=[repmat(renderwallcorners,length(minh:maxh),1),tmp(:)];
    [ renderwallcorners ] = transform_3d( renderwallcorners,camxyz,orientation,tilt );
    wallcornersfn=tmp(:)/wallheight+nowfn-1;
else
    renderwallcorners=[];
    wallcornersfn=[];
end

%windows
if sum(windowpointvisibility)>0
    renderwindowpoints=windowpoints(windowpointvisibility,:);
    renderwindowpoints1=[renderwindowpoints,zeros(size(renderwindowpoints,1),1)];
    renderwindowpoints2=[renderwindowpoints,ones(size(renderwindowpoints,1),1)*windowbot];
    renderwindowpoints3=[renderwindowpoints,ones(size(renderwindowpoints,1),1)*windowtop];
    [ renderwindowpoints1 ] = transform_3d( renderwindowpoints1,camxyz,orientation,tilt );
    [ renderwindowpoints2 ] = transform_3d( renderwindowpoints2,camxyz,orientation,tilt );
    [ renderwindowpoints3 ] = transform_3d( renderwindowpoints3,camxyz,orientation,tilt );
    windowpointsfn=ones(size(renderwindowpoints1,1),1)*(nowfn-1);
else
    renderwindowpoints1=[];renderwindowpoints2=[];renderwindowpoints3=[];
    windowpointsfn=[];
end
if sum(windowedgesvisibility>0)
    renderwindowedges=windowedges(windowedgesvisibility,:);
    minh=windowbot;maxh=windowtop;
    tmp=repmat((minh:maxh),size(renderwindowedges,1),1);
    renderwindowedges=[repmat(renderwindowedges,length((minh:maxh)),1),tmp(:)];
    [ renderwindowedges ] = transform_3d( renderwindowedges,camxyz,orientation,tilt );
    windowedgesfn=ones(size(renderwindowedges,1),1)*(nowfn-1);
else
    renderwindowedges=[];
    windowedgesfn=[];
end

%doors
if sum(doorpointvisibility>0)
    renderdoorpoints=doorpoints(doorpointvisibility,:);
    renderdoorpoints1=[renderdoorpoints,zeros(size(renderdoorpoints,1),1)];
    renderdoorpoints2=[renderdoorpoints,ones(size(renderdoorpoints,1),1)*doorheight];
    [ renderdoorpoints1 ] = transform_3d( renderdoorpoints1,camxyz,orientation,tilt );
    [ renderdoorpoints2 ] = transform_3d( renderdoorpoints2,camxyz,orientation,tilt );
    doorpointsfn=ones(size(renderdoorpoints1,1),1)*(nowfn-1);
else
    renderdoorpoints1=[];renderdoorpoints2=[];
    doorpointsfn=[];
end
if sum(dooredgesvisibility>0)
    renderdooredges=dooredges(dooredgesvisibility,:);
    minh=0;maxh=doorheight;
    tmp=repmat((minh:maxh),size(renderdooredges,1),1);
    renderdooredges=[repmat(renderdooredges,length(minh:maxh),1),tmp(:)];
    [ renderdooredges ] = transform_3d( renderdooredges,camxyz,orientation,tilt );
    dooredgesfn=ones(size(renderdooredges,1),1)*(nowfn-1);
else
    renderdooredges=[];
    dooredgesfn=[];
end

renderresult.renderwallpoints=renderwallpoints;
renderresult.renderwindowpoints1=renderwindowpoints1;
renderresult.renderwindowpoints2=renderwindowpoints2;
renderresult.renderwindowpoints3=renderwindowpoints3;
renderresult.renderdoorpoints1=renderdoorpoints1;
renderresult.renderdoorpoints2=renderdoorpoints2;
renderresult.renderwallcorners=renderwallcorners;
renderresult.renderdooredges=renderdooredges;
renderresult.renderwindowedges=renderwindowedges;

renderresult.wallpointsfn=wallpointsfn;
renderresult.wallcornersfn=wallcornersfn;
renderresult.windowpointsfn=windowpointsfn;
renderresult.windowedgesfn=windowedgesfn;
renderresult.doorpointsfn=doorpointsfn;
renderresult.dooredgesfn=dooredgesfn;

if display==1
    figure;
    hold on;
    if size(renderwallpoints,1)>0
        plot(renderwallpoints(:,1)./renderwallpoints(:,3),-renderwallpoints(:,2)./renderwallpoints(:,3),'r.')
    end
    if size(renderwindowpoints1,1)>0
        plot(renderwindowpoints1(:,1)./renderwindowpoints1(:,3),-renderwindowpoints1(:,2)./renderwindowpoints1(:,3),'g.')
    end
    if size(renderwindowpoints2,1)>0
        plot(renderwindowpoints2(:,1)./renderwindowpoints2(:,3),-renderwindowpoints2(:,2)./renderwindowpoints2(:,3),'g.')
    end
    if size(renderwindowpoints3,1)>0
        plot(renderwindowpoints3(:,1)./renderwindowpoints3(:,3),-renderwindowpoints3(:,2)./renderwindowpoints3(:,3),'g.')
    end
    if size(renderdoorpoints1,1)>0
        plot(renderdoorpoints1(:,1)./renderdoorpoints1(:,3),-renderdoorpoints1(:,2)./renderdoorpoints1(:,3),'b.')
    end
    if size(renderdoorpoints2,1)>0
        plot(renderdoorpoints2(:,1)./renderdoorpoints2(:,3),-renderdoorpoints2(:,2)./renderdoorpoints2(:,3),'b.')
    end
    if size(renderwallcorners,1)>0
        plot(renderwallcorners(:,1)./renderwallcorners(:,3),-renderwallcorners(:,2)./renderwallcorners(:,3),'y.')
    end
    if size(renderdooredges,1)>0
        plot(renderdooredges(:,1)./renderdooredges(:,3),-renderdooredges(:,2)./renderdooredges(:,3),'b.')
    end
    if size(renderwindowedges,1)>0
        plot(renderwindowedges(:,1)./renderwindowedges(:,3),-renderwindowedges(:,2)./renderwindowedges(:,3),'g.')
    end
    axis equal
    hold off;
end
