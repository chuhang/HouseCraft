function [ renderresult_homography,renderresult_homography_3D ] = homography_for_rendered_3D_floor( H,K,renderresult,transformed_image,display )
renderwallpoints=renderresult.renderwallpoints;
renderwindowpoints1=renderresult.renderwindowpoints1;
renderwindowpoints2=renderresult.renderwindowpoints2;
renderwindowpoints3=renderresult.renderwindowpoints3;
renderdoorpoints1=renderresult.renderdoorpoints1;
renderdoorpoints2=renderresult.renderdoorpoints2;
renderwallcorners=renderresult.renderwallcorners;
renderdooredges=renderresult.renderdooredges;
renderwindowedges=renderresult.renderwindowedges;

if size(renderwallpoints,1)>0
    renderwallpoints=renderwallpoints(renderwallpoints(:,3)>0,:);
    renderresult_homography.wallpointsfn=renderresult.wallpointsfn(renderwallpoints(:,3)>0,:);
    renderresult_homography_3D.wallpointsfn=renderresult.wallpointsfn(renderwallpoints(:,3)>0,:);
else
    renderresult_homography.wallpointsfn=[];
    renderresult_homography_3D.wallpointsfn=[];
end
if size(renderwindowpoints1,1)>0
    renderwindowpoints1=renderwindowpoints1(renderwindowpoints1(:,3)>0,:);
    renderresult_homography.windowpointsfn=renderresult.windowpointsfn(renderwindowpoints1(:,3)>0,:);
    renderresult_homography_3D.windowpointsfn=renderresult.windowpointsfn(renderwindowpoints1(:,3)>0,:);
else
    renderresult_homography.windowpointsfn=[];
    renderresult_homography_3D.windowpointsfn=[];
end
if size(renderwindowpoints2,1)>0
    renderwindowpoints2=renderwindowpoints2(renderwindowpoints2(:,3)>0,:);
end
if size(renderwindowpoints3,1)>0
    renderwindowpoints3=renderwindowpoints3(renderwindowpoints3(:,3)>0,:);
end
if size(renderdoorpoints1,1)>0
    renderdoorpoints1=renderdoorpoints1(renderdoorpoints1(:,3)>0,:);
    renderresult_homography.doorpointsfn=renderresult.doorpointsfn(renderdoorpoints1(:,3)>0,:);
    renderresult_homography_3D.doorpointsfn=renderresult.doorpointsfn(renderdoorpoints1(:,3)>0,:);
else
    renderresult_homography.doorpointsfn=[];
    renderresult_homography_3D.doorpointsfn=[];
end
if size(renderdoorpoints2,1)>0
    renderdoorpoints2=renderdoorpoints2(renderdoorpoints2(:,3)>0,:);
end
if size(renderwallcorners,1)>0
    renderwallcorners=renderwallcorners(renderwallcorners(:,3)>0,:);
    renderresult_homography.wallcornersfn=renderresult.wallcornersfn(renderwallcorners(:,3)>0,:);
    renderresult_homography_3D.wallcornersfn=renderresult.wallcornersfn(renderwallcorners(:,3)>0,:);
else
    renderresult_homography.wallcornersfn=[];
    renderresult_homography_3D.wallcornersfn=[];
end
if size(renderdooredges,1)>0
    renderdooredges=renderdooredges(renderdooredges(:,3)>0,:);
    renderresult_homography.dooredgesfn=renderresult.dooredgesfn(renderdooredges(:,3)>0,:);
    renderresult_homography_3D.dooredgesfn=renderresult.dooredgesfn(renderdooredges(:,3)>0,:);
else
    renderresult_homography.dooredgesfn=[];
    renderresult_homography_3D.dooredgesfn=[];
end
if size(renderwindowedges,1)>0
    renderwindowedges=renderwindowedges(renderwindowedges(:,3)>0,:);
    renderresult_homography.windowedgesfn=renderresult.windowedgesfn(renderwindowedges(:,3)>0,:);
    renderresult_homography_3D.windowedgesfn=renderresult.windowedgesfn(renderwindowedges(:,3)>0,:);
else
    renderresult_homography.windowedgesfn=[];
    renderresult_homography_3D.windowedgesfn=[];
end

%apply tform
if size(renderwallpoints,1)>0
    tmp=(H*K*(renderwallpoints'))';
    renderresult_homography_3D.wallpoints=tmp;
    renderresult_homography.wallpoints=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.wallpoints=[];
    renderresult_homography_3D.wallpoints=[];
end
if size(renderwindowpoints1,1)>0
    tmp=(H*K*(renderwindowpoints1'))';
    renderresult_homography_3D.windowpoints1=tmp;
    renderresult_homography.windowpoints1=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.windowpoints1=[];
    renderresult_homography_3D.windowpoints1=[];
end
if size(renderwindowpoints2,1)>0
    tmp=(H*K*(renderwindowpoints2'))';
    renderresult_homography_3D.windowpoints2=tmp;
    renderresult_homography.windowpoints2=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.windowpoints2=[];
    renderresult_homography_3D.windowpoints2=[];
end
if size(renderwindowpoints3,1)>0
    tmp=(H*K*(renderwindowpoints3'))';
    renderresult_homography_3D.windowpoints3=tmp;
    renderresult_homography.windowpoints3=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.windowpoints3=[];
    renderresult_homography_3D.windowpoints3=[];
end
if size(renderdoorpoints1,1)>0
    tmp=(H*K*(renderdoorpoints1'))';
    renderresult_homography_3D.doorpoints1=tmp;
    renderresult_homography.doorpoints1=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.doorpoints1=[];
    renderresult_homography_3D.doorpoints1=[];
end
if size(renderdoorpoints2,1)>0
    tmp=(H*K*(renderdoorpoints2'))';
    renderresult_homography_3D.doorpoints2=tmp;
    renderresult_homography.doorpoints2=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.doorpoints2=[];
    renderresult_homography_3D.doorpoints2=[];
end
if size(renderwallcorners,1)>0
    tmp=(H*K*(renderwallcorners'))';
    renderresult_homography_3D.wallcorners=tmp;
    renderresult_homography.wallcorners=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.wallcorners=[];
    renderresult_homography_3D.wallcorners=[];
end
if size(renderdooredges,1)>0
    tmp=(H*K*(renderdooredges'))';
    renderresult_homography_3D.dooredges=tmp;
    renderresult_homography.dooredges=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.dooredges=[];
    renderresult_homography_3D.dooredges=[];
end
if size(renderwindowedges,1)>0
    tmp=(H*K*(renderwindowedges'))';
    renderresult_homography_3D.windowedges=tmp;
    renderresult_homography.windowedges=[tmp(:,1)./tmp(:,3),tmp(:,2)./tmp(:,3)];
else
    renderresult_homography.windowedges=[];
    renderresult_homography_3D.windowedges=[];
end

%display
if display==1
    figure;
    imshow(transformed_image);
    hold on;
    if size(renderresult_homography.wallpoints,1)>0
        plot(renderresult_homography.wallpoints(:,1),renderresult_homography.wallpoints(:,2),'r.');
    end
    if size(renderresult_homography.windowpoints1,1)>0
        plot(renderresult_homography.windowpoints1(:,1),renderresult_homography.windowpoints1(:,2),'g.');
    end
    if size(renderresult_homography.windowpoints2,1)>0
        plot(renderresult_homography.windowpoints2(:,1),renderresult_homography.windowpoints2(:,2),'g.');
    end
    if size(renderresult_homography.windowpoints3,1)>0
        plot(renderresult_homography.windowpoints3(:,1),renderresult_homography.windowpoints3(:,2),'g.');
    end
    if size(renderresult_homography.doorpoints1,1)>0
        plot(renderresult_homography.doorpoints1(:,1),renderresult_homography.doorpoints1(:,2),'b.');
    end
    if size(renderresult_homography.doorpoints2,1)>0
        plot(renderresult_homography.doorpoints2(:,1),renderresult_homography.doorpoints2(:,2),'b.');
    end
    if size(renderresult_homography.wallcorners,1)>0
        plot(renderresult_homography.wallcorners(:,1),renderresult_homography.wallcorners(:,2),'y.');
    end
    if size(renderresult_homography.dooredges,1)>0
        plot(renderresult_homography.dooredges(:,1),renderresult_homography.dooredges(:,2),'b.');
    end
    if size(renderresult_homography.windowedges,1)>0
        plot(renderresult_homography.windowedges(:,1),renderresult_homography.windowedges(:,2),'g.');
    end
end
end