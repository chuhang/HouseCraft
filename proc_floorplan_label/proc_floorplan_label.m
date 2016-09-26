function [ walls,wallcorners,windows,doors,dooredges,windowedges,imgsize ] = proc_floorplan_label( floorplan_imgpath,display )
img=imread(floorplan_imgpath);
labelimg=zeros(size(img,1),size(img,2));
labelimg((img(:,:,1)==255)&(img(:,:,2)==0)&(img(:,:,3)==0))=1;
labelimg((img(:,:,1)==255)&(img(:,:,2)==255)&(img(:,:,3)==0))=2;
labelimg((img(:,:,1)==0)&(img(:,:,2)==255)&(img(:,:,3)==0))=3;
labelimg((img(:,:,1)==0)&(img(:,:,2)==0)&(img(:,:,3)==255))=4;

cc=bwconncomp(labelimg==2);
for ii=1:length(cc.PixelIdxList)
    [yy,xx]=ind2sub(cc.ImageSize,cc.PixelIdxList{ii});
    wallcorners(ii,1:2)=[mean(xx),mean(yy)];
end
cc=bwconncomp(labelimg==3);
windows=[];
for ii=1:length(cc.PixelIdxList)
    [yy,xx]=ind2sub(cc.ImageSize,cc.PixelIdxList{ii});
    usepx=0;usepy=0;
    if std(xx)>std(yy)
        p=polyfit(xx,yy,1);
        usepx=1;
    else
        p=polyfit(yy,xx,1);
        usepy=1;
    end
    if usepx==1
        pt1=[min(xx),p(2)+p(1)*min(xx)];
        pt2=[max(xx),p(2)+p(1)*max(xx)];
    elseif usepy==1
        pt1=[p(2)+p(1)*min(yy),min(yy)];
        pt2=[p(2)+p(1)*max(yy),max(yy)];
    end
    windows=[windows;pt1,pt2];
end
cc=bwconncomp(labelimg==4);
doors=[];
for ii=1:length(cc.PixelIdxList)
    [yy,xx]=ind2sub(cc.ImageSize,cc.PixelIdxList{ii});
    usepx=0;usepy=0;
    if std(xx)>std(yy)
        p=polyfit(xx,yy,1);
        usepx=1;
    else
        p=polyfit(yy,xx,1);
        usepy=1;
    end
    if usepx==1
        pt1=[min(xx),p(2)+p(1)*min(xx)];
        pt2=[max(xx),p(2)+p(1)*max(xx)];
    elseif usepy==1
        pt1=[p(2)+p(1)*min(yy),min(yy)];
        pt2=[p(2)+p(1)*max(yy),max(yy)];
    end
    doors=[doors;pt1,pt2];
end
cc=bwconncomp(labelimg==1);
walls=[];
for ii=1:length(cc.PixelIdxList)
    [yy,xx]=ind2sub(cc.ImageSize,cc.PixelIdxList{ii});
    usepx=0;usepy=0;
    if std(xx)>std(yy)
        p=polyfit(xx,yy,1);
        usepx=1;
    else
        p=polyfit(yy,xx,1);
        usepy=1;
    end
    if usepx==1
        pt1=[min(xx),p(2)+p(1)*min(xx)];
        pt2=[max(xx),p(2)+p(1)*max(xx)];
    elseif usepy==1
        pt1=[p(2)+p(1)*min(yy),min(yy)];
        pt2=[p(2)+p(1)*max(yy),max(yy)];
    end
    walls=[walls;pt1,pt2];
end

%allpts=[wallcorners;windows(:,1:2);windows(:,3:4);doors(:,1:2);doors(:,3:4)];
allpts=wallcorners;
if size(windows,1)>0
    allpts=[allpts;windows(:,1:2);windows(:,3:4);];
end
if size(doors,1)>0
    allpts=[allpts;doors(:,1:2);doors(:,3:4);];
end
for ii=1:size(walls,1)
    nowpt=walls(ii,1:2);
    dis=sqrt(sum((allpts-repmat(nowpt,size(allpts,1),1)).^2,2));
    [~,ind]=min(dis);
    walls(ii,1:2)=allpts(ind,1:2);
    nowpt=walls(ii,3:4);
    dis=sqrt(sum((allpts-repmat(nowpt,size(allpts,1),1)).^2,2));
    [~,ind]=min(dis);
    walls(ii,3:4)=allpts(ind,1:2);
end
imgsize=[size(img,1),size(img,2)];

%sort wallcorners
cd ./travelling_salesman
userConfig=struct('XY',wallcorners,'NUMITER',1000,'showProg',false,'showResult',false,'showWaitbar',false);
resultStruct=tsp_ga(userConfig);
wallcorners=wallcorners(resultStruct.optRoute',:);
cd ..

if size(doors,1)>0
    dooredges=[doors(:,1:2);doors(:,3:4)];
else
    dooredges=[];
end
if size(windows,1)>0
    windowedges=[windows(:,1:2);windows(:,3:4)];
else
    windowedges=[];
end

if display==1
    figure;
    hold on;
    for ii=1:size(walls,1)
        plot([walls(ii,1);walls(ii,3)],-[walls(ii,2);walls(ii,4)],'r','LineWidth',3);
    end
    for ii=1:size(windows,1)
        plot([windows(ii,1);windows(ii,3)],-[windows(ii,2);windows(ii,4)],'g','LineWidth',3);
    end
    for ii=1:size(doors,1)
        plot([doors(ii,1);doors(ii,3)],-[doors(ii,2);doors(ii,4)],'b','LineWidth',3);
    end
    axis equal;
    hold off;
end
end