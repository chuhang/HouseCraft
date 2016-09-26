function [ allrenderresult ] = merge_on_img_render( renderresult,img_data,display )
len=length(renderresult);
allrenderresult=renderresult{1};
if len>1
    for ii=2:len
        allrenderresult.walllines=[allrenderresult.walllines;renderresult{ii}.walllines;];
        allrenderresult.wallcornerlines=[allrenderresult.wallcornerlines;renderresult{ii}.wallcornerlines;];
        allrenderresult.renderwindowrects=[allrenderresult.renderwindowrects;renderresult{ii}.renderwindowrects;];
        allrenderresult.renderdoorrects=[allrenderresult.renderdoorrects;renderresult{ii}.renderdoorrects;];
        allrenderresult.walllinesfn=[allrenderresult.walllinesfn;renderresult{ii}.walllinesfn;];
        allrenderresult.wallcornerlinessfn=[allrenderresult.wallcornerlinessfn;renderresult{ii}.wallcornerlinessfn;];
        allrenderresult.windowrectsfn=[allrenderresult.windowrectsfn;renderresult{ii}.windowrectsfn;];
        allrenderresult.doorrectsfn=[allrenderresult.doorrectsfn;renderresult{ii}.doorrectsfn;];
    end
end

if display==1
    newlines=allrenderresult.walllines;
    newvertlines=allrenderresult.wallcornerlines;
    newwindows=allrenderresult.renderwindowrects;
    newdoors=allrenderresult.renderdoorrects;
    
    HSV = rgb2hsv(img_data);
    % "20% more" saturation:
    HSV(:, :, 2) = HSV(:, :, 2) * 2;
    img_data = hsv2rgb(HSV);
    
    figure;
    imshow(img_data);
    hold on;
    for ii=1:(size(newlines,1)/2)
        fill([newlines(2*ii-1,1);newlines(2*ii-1,3);newlines(2*ii,3);newlines(2*ii,1);],[newlines(2*ii-1,2);newlines(2*ii-1,4);newlines(2*ii,4);newlines(2*ii,2);],[234,113,38]/255,'EdgeColor','none','FaceAlpha',0.7,'LineWidth',2);
    end
    for ii=1:size(newlines,1)
        plot([newlines(ii,1);newlines(ii,3);],[newlines(ii,2);newlines(ii,4);],'k','LineWidth',4);
    end
    for ii=1:size(newvertlines,1)
        plot([newvertlines(ii,1);newvertlines(ii,3);],[newvertlines(ii,2);newvertlines(ii,4);],'k','LineWidth',4);
    end
    for ii=1:size(newwindows,1)
        fill([newwindows(ii,1);newwindows(ii,3);newwindows(ii,5);newwindows(ii,7);],[newwindows(ii,2);newwindows(ii,4);newwindows(ii,6);newwindows(ii,8);],[142,220,157]/255,'FaceAlpha',0.7,'LineWidth',4);
    end
    for ii=1:size(newdoors,1)
        fill([newdoors(ii,1);newdoors(ii,3);newdoors(ii,5);newdoors(ii,7);],[newdoors(ii,2);newdoors(ii,4);newdoors(ii,6);newdoors(ii,8);],[33,140,141]/255,'FaceAlpha',0.7,'LineWidth',4);
    end
    hold off;
end
if display==2
    newlines=allrenderresult.walllines;
    newvertlines=allrenderresult.wallcornerlines;
    newwindows=allrenderresult.renderwindowrects;
    newdoors=allrenderresult.renderdoorrects;
    
    HSV = rgb2hsv(img_data);
    % "20% more" saturation:
    HSV(:, :, 2) = HSV(:, :, 2) * 2;
    img_data = hsv2rgb(HSV);
    
    figure;
    imshow(img_data);
end
end