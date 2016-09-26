function [ allrenderresult ] = merge_renderresult_floor( renderresult )
len=length(renderresult);
allrenderresult=renderresult{1};
if len>1
    for ii=2:len
        allrenderresult.renderwallpoints=[allrenderresult.renderwallpoints;renderresult{ii}.renderwallpoints;];
        allrenderresult.renderwindowpoints1=[allrenderresult.renderwindowpoints1;renderresult{ii}.renderwindowpoints1;];
        allrenderresult.renderwindowpoints2=[allrenderresult.renderwindowpoints2;renderresult{ii}.renderwindowpoints2;];
        allrenderresult.renderwindowpoints3=[allrenderresult.renderwindowpoints3;renderresult{ii}.renderwindowpoints3;];
        allrenderresult.renderdoorpoints1=[allrenderresult.renderdoorpoints1;renderresult{ii}.renderdoorpoints1;];
        allrenderresult.renderdoorpoints2=[allrenderresult.renderdoorpoints2;renderresult{ii}.renderdoorpoints2;];
        allrenderresult.renderwallcorners=[allrenderresult.renderwallcorners;renderresult{ii}.renderwallcorners;];
        allrenderresult.renderdooredges=[allrenderresult.renderdooredges;renderresult{ii}.renderdooredges;];
        allrenderresult.renderwindowedges=[allrenderresult.renderwindowedges;renderresult{ii}.renderwindowedges;];
        
        allrenderresult.wallpointsfn=[allrenderresult.wallpointsfn;renderresult{ii}.wallpointsfn;];
        allrenderresult.wallcornersfn=[allrenderresult.wallcornersfn;renderresult{ii}.wallcornersfn;];
        allrenderresult.windowpointsfn=[allrenderresult.windowpointsfn;renderresult{ii}.windowpointsfn;];
        allrenderresult.windowedgesfn=[allrenderresult.windowedgesfn;renderresult{ii}.windowedgesfn;];
        allrenderresult.doorpointsfn=[allrenderresult.doorpointsfn;renderresult{ii}.doorpointsfn;];
        allrenderresult.dooredgesfn=[allrenderresult.dooredgesfn;renderresult{ii}.dooredgesfn;];
    end
end
end