function [ onimgresult ] = visualize_onimg( exact_renderresult,img_data,display )
if size(exact_renderresult.walllines,1)>0
    lines=exact_renderresult.walllines;
    newlines=[lines(:,1)./lines(:,3)*300+280,lines(:,2)./lines(:,3)*300+180,lines(:,4)./lines(:,6)*300+280,lines(:,5)./lines(:,6)*300+180];
else
    newlines=[];
end
if size(exact_renderresult.wallcornerlines,1)>0
    vertlines=exact_renderresult.wallcornerlines;
    newvertlines=[vertlines(:,1)./vertlines(:,3)*300+280,vertlines(:,2)./vertlines(:,3)*300+180,vertlines(:,4)./vertlines(:,6)*300+280,vertlines(:,5)./vertlines(:,6)*300+180];
else
    newvertlines=[];
end
if size(exact_renderresult.renderwindowrects,1)>0
    windows=exact_renderresult.renderwindowrects;
    newwindows=[windows(:,1)./windows(:,3)*300+280,windows(:,2)./windows(:,3)*300+180,windows(:,4)./windows(:,6)*300+280,windows(:,5)./windows(:,6)*300+180,windows(:,7)./windows(:,9)*300+280,windows(:,8)./windows(:,9)*300+180,windows(:,10)./windows(:,12)*300+280,windows(:,11)./windows(:,12)*300+180];
else
    newwindows=[];
end
if size(exact_renderresult.renderdoorrects,1)>0
    doors=exact_renderresult.renderdoorrects;
    newdoors=[doors(:,1)./doors(:,3)*300+280,doors(:,2)./doors(:,3)*300+180,doors(:,4)./doors(:,6)*300+280,doors(:,5)./doors(:,6)*300+180,doors(:,7)./doors(:,9)*300+280,doors(:,8)./doors(:,9)*300+180,doors(:,10)./doors(:,12)*300+280,doors(:,11)./doors(:,12)*300+180];
else
    newdoors=[];
end

oldnewlines=newlines;
newlines=[];
tmp=size(oldnewlines,1)/2;
for ii=1:tmp
    newlines=[newlines;oldnewlines(ii,:);oldnewlines(tmp+ii,:)];
end

onimgresult.walllines=newlines;
onimgresult.wallcornerlines=newvertlines;
onimgresult.renderwindowrects=newwindows;
onimgresult.renderdoorrects=newdoors;
onimgresult.walllinesfn=exact_renderresult.walllinesfn;
onimgresult.wallcornerlinessfn=exact_renderresult.wallcornerlinessfn;
onimgresult.windowrectsfn=exact_renderresult.windowrectsfn;
onimgresult.doorrectsfn=exact_renderresult.doorrectsfn;

if display==1
    figure;
    imshow(img_data);
    hold on;
    for ii=1:size(newlines,1)
        plot([newlines(ii,1);newlines(ii,3);],[newlines(ii,2);newlines(ii,4);],'r');
    end
    for ii=1:size(newvertlines,1)
        plot([newvertlines(ii,1);newvertlines(ii,3);],[newvertlines(ii,2);newvertlines(ii,4);],'r');
    end
    for ii=1:size(newwindows,1)
        plot([newwindows(ii,1);newwindows(ii,3);newwindows(ii,5);newwindows(ii,7);newwindows(ii,1);],[newwindows(ii,2);newwindows(ii,4);newwindows(ii,6);newwindows(ii,8);newwindows(ii,2);],'g');
    end
    for ii=1:size(newdoors,1)
        plot([newdoors(ii,1);newdoors(ii,3);newdoors(ii,5);newdoors(ii,7);newdoors(ii,1);],[newdoors(ii,2);newdoors(ii,4);newdoors(ii,6);newdoors(ii,8);newdoors(ii,2);],'g');
    end
    hold off;
end
end