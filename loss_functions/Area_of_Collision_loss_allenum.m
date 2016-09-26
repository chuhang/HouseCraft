function [ wallloss,windowloss,doorloss,label ] = Area_of_Collision_loss_allenum( renderlinerects_homography_batched,all_building_deformations )
%-----step 1: find optimal building configuration
searchsz=size(all_building_deformations,1);
for ii=1:7
    ids(1:searchsz,ii)=(abs(all_building_deformations(:,ii))==min(abs(all_building_deformations(:,ii))));
end
finalids=(ids(:,1)&ids(:,2)&ids(:,3)&ids(:,4)&ids(:,5)&ids(:,6)&ids(:,7));
optimalid=find(finalids);

%-----step 2: compute loss for wall (entire building facade)
allpointsx=[];
data=renderlinerects_homography_batched.wallhori(:,1);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsx=[allpointsx,data'];
data=renderlinerects_homography_batched.wallhori(:,3);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsx=[allpointsx,data'];
data=renderlinerects_homography_batched.wallvert(:,1);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsx=[allpointsx,data'];
data=renderlinerects_homography_batched.wallvert(:,3);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsx=[allpointsx,data'];
allpointsy=[];
data=renderlinerects_homography_batched.wallhori(:,2);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsy=[allpointsy,data'];
data=renderlinerects_homography_batched.wallhori(:,4);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsy=[allpointsy,data'];
data=renderlinerects_homography_batched.wallvert(:,2);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsy=[allpointsy,data'];
data=renderlinerects_homography_batched.wallvert(:,4);
data=reshape(data,size(data,1)/searchsz,searchsz);
allpointsy=[allpointsy,data'];

xmins=min(allpointsx')';
xmaxs=max(allpointsx')';
ymins=min(allpointsy')';
ymaxs=max(allpointsy')';
gts=repmat([xmins(optimalid),ymins(optimalid),xmaxs(optimalid)-xmins(optimalid),ymaxs(optimalid)-ymins(optimalid)],searchsz,1);
prs=[xmins,ymins,xmaxs-xmins,ymaxs-ymins];
[ overlapArea ] = iou_vecterised( gts,prs );
wallloss=1-overlapArea;

%-----step 3: compute loss for window
totaloverlaparea=zeros(searchsz,1);
if size(renderlinerects_homography_batched.window,1)>0
    objnum=size(renderlinerects_homography_batched.window,1)/searchsz;
    xmins=reshape(renderlinerects_homography_batched.window(:,1),objnum,searchsz)';
    ymins=reshape(renderlinerects_homography_batched.window(:,2),objnum,searchsz)';
    xmaxs=reshape(renderlinerects_homography_batched.window(:,3),objnum,searchsz)';
    ymaxs=reshape(renderlinerects_homography_batched.window(:,4),objnum,searchsz)';
    for ii=1:objnum
        gts=repmat([xmins(optimalid,ii),ymins(optimalid,ii),xmaxs(optimalid,ii)-xmins(optimalid,ii),ymaxs(optimalid,ii)-ymins(optimalid,ii)],searchsz,1);
        prs=[xmins(:,ii),ymins(:,ii),xmaxs(:,ii)-xmins(:,ii),ymaxs(:,ii)-ymins(:,ii)];
        [ overlapArea ] = iou_vecterised( gts,prs );
        totaloverlaparea=totaloverlaparea+overlapArea;
    end
    windowloss=(objnum-totaloverlaparea)/objnum;
else
    windowloss=zeros(searchsz,1);
end

%-----step 4: compute loss for door
totaloverlaparea=zeros(searchsz,1);
if size(renderlinerects_homography_batched.door,1)>0
    objnum=size(renderlinerects_homography_batched.door,1)/searchsz;
    xmins=reshape(renderlinerects_homography_batched.door(:,1),objnum,searchsz)';
    ymins=reshape(renderlinerects_homography_batched.door(:,2),objnum,searchsz)';
    xmaxs=reshape(renderlinerects_homography_batched.door(:,3),objnum,searchsz)';
    ymaxs=reshape(renderlinerects_homography_batched.door(:,4),objnum,searchsz)';
    for ii=1:objnum
        gts=repmat([xmins(optimalid,ii),ymins(optimalid,ii),xmaxs(optimalid,ii)-xmins(optimalid,ii),ymaxs(optimalid,ii)-ymins(optimalid,ii)],searchsz,1);
        prs=[xmins(:,ii),ymins(:,ii),xmaxs(:,ii)-xmins(:,ii),ymaxs(:,ii)-ymins(:,ii)];
        [ overlapArea ] = iou_vecterised( gts,prs );
        totaloverlaparea=totaloverlaparea+overlapArea;
    end
    doorloss=(objnum-totaloverlaparea)/objnum;
else
    doorloss=zeros(searchsz,1);
end

label=optimalid;
end