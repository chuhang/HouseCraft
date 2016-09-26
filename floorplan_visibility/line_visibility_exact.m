function [ visiblewalls,visiblewindows,visibledoors ] = line_visibility_exact( camposition,walls,windows,doors,display )
alllines=[walls;windows;doors;];
alllinestypes=[ones(size(walls,1),1);2*ones(size(windows,1),1);3*ones(size(doors,1),1);];
allpoints=[alllines(:,1:2);alllines(:,3:4);];

%get rid of repeating points
usethatpt=ones(size(allpoints,1),1);
for ii=1:(size(allpoints,1)-1)
    if usethatpt(ii)==1
        for jj=(ii+1):size(allpoints,1)
            if norm(allpoints(jj,:)-allpoints(ii,:))<0.0001
                usethatpt(jj)=0;
            end
        end
    end
end
allpoints=allpoints(usethatpt==1,:);

angles=atan2(allpoints(:,2)-camposition(2),allpoints(:,1)-camposition(1));
if (max(angles)>pi/2) && (min(angles)<(-pi/2))
    angles(angles>0)=angles(angles>0)-2*pi;
end
sortedangles=sort(angles,'ascend');
startangles=sortedangles(1:(end-1),:);
endangles=sortedangles(2:end,:);
midangles=(startangles+endangles)/2;

pts1=repmat(camposition,size(midangles,1),1);
pts2=pts1+1000*[cos(midangles),sin(midangles)];
intersectout=lineSegmentIntersect([pts1,pts2],alllines);
isintersect=intersectout.intAdjacencyMatrix;
intersectX=intersectout.intMatrixX;
intersectY=intersectout.intMatrixY;

dis2cam=sqrt((intersectX-camposition(1)).^2+(intersectY-camposition(2)).^2);
dis2cam(~isintersect)=Inf;
[mindis,whichline]=min(dis2cam');
mindis=mindis';
whichline=whichline';

visminangle=ones(size(alllines,1),1)*Inf;
vismaxangle=-ones(size(alllines,1),1)*Inf;
for ii=1:length(whichline)
    if ~isinf(mindis(ii))
        if startangles(ii)<visminangle(whichline(ii))
            visminangle(whichline(ii))=startangles(ii);
        end
        if endangles(ii)>vismaxangle(whichline(ii))
            vismaxangle(whichline(ii))=endangles(ii);
        end
    end
end

visiblewalls=[];
visiblewindows=[];
visibledoors=[];
for ii=1:size(alllines,1)
    if ~isinf(visminangle(ii))
        lineray=cross([alllines(ii,1:2),1],[alllines(ii,3:4),1]);
        minray=cross([camposition,1],[camposition(1)+cos(visminangle(ii)),camposition(2)+sin(visminangle(ii)),1]);
        maxray=cross([camposition,1],[camposition(1)+cos(vismaxangle(ii)),camposition(2)+sin(vismaxangle(ii)),1]);
        tmp=cross(lineray,minray);
        minpt=[tmp(1)/tmp(3),tmp(2)/tmp(3)];
        tmp=cross(lineray,maxray);
        maxpt=[tmp(1)/tmp(3),tmp(2)/tmp(3)];
        if norm(maxpt-minpt)>0.2
            if alllinestypes(ii)==1
                visiblewalls=[visiblewalls;minpt,maxpt;];
            end
            if alllinestypes(ii)==2
                visiblewindows=[visiblewindows;minpt,maxpt;];
                visiblewalls=[visiblewalls;minpt,maxpt;];
            end
            if alllinestypes(ii)==3
                visibledoors=[visibledoors;minpt,maxpt;];
                visiblewalls=[visiblewalls;minpt,maxpt;];
            end
        end
    end
end

% visiblewalls=[];
% visiblewindows=[];
% visibledoors=[];
% for ii=1:length(whichline)
%     if ~isinf(mindis(ii))
%         lineray=cross([alllines(whichline(ii),1:2),1],[alllines(whichline(ii),3:4),1]);
%         minray=cross([camposition,1],[camposition(1)+cos(startangles(ii)),camposition(2)+sin(startangles(ii)),1]);
%         maxray=cross([camposition,1],[camposition(1)+cos(endangles(ii)),camposition(2)+sin(endangles(ii)),1]);
%         tmp=cross(lineray,minray);
%         minpt=[tmp(1)/tmp(3),tmp(2)/tmp(3)];
%         tmp=cross(lineray,maxray);
%         maxpt=[tmp(1)/tmp(3),tmp(2)/tmp(3)];
%         if norm(maxpt-minpt)>0.2
%             if alllinestypes(whichline(ii))==1
%                 visiblewalls=[visiblewalls;minpt,maxpt;];
%             end
%             if alllinestypes(whichline(ii))==2
%                 visiblewindows=[visiblewindows;minpt,maxpt;];
%                 visiblewalls=[visiblewalls;minpt,maxpt;];
%             end
%             if alllinestypes(whichline(ii))==3
%                 visibledoors=[visibledoors;minpt,maxpt;];
%                 visiblewalls=[visiblewalls;minpt,maxpt;];
%             end
%         end
%     end
% end

if display==1
    figure;
    hold on;
    plot(camposition(1),camposition(2),'k.','MarkerSize',25);
    for ii=1:size(visiblewalls,1)
        plot([visiblewalls(ii,1);visiblewalls(ii,3)],[visiblewalls(ii,2);visiblewalls(ii,4)],'r*-');
    end
    for ii=1:size(visiblewindows,1)
        plot([visiblewindows(ii,1);visiblewindows(ii,3)],[visiblewindows(ii,2);visiblewindows(ii,4)],'g*-');
    end
    for ii=1:size(visibledoors,1)
        plot([visibledoors(ii,1);visibledoors(ii,3)],[visibledoors(ii,2);visibledoors(ii,4)],'b*-');
    end
    axis equal;
    hold off;
end
end