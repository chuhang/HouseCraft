function [ doorpoints,windowpoints,wallpoints ] = pointalize_floorplan_scale( doors,windows,walls,pixel2meter,display )
rate=floor(pixel2meter/4);
[ doorpoints ] = lines2points( doors,rate );
[ windowpoints ] = lines2points( windows,rate );
[ wallpoints ] = lines2points( walls,rate );

if display==1
    figure;
    hold on;
    if size(doorpoints,1)>0
        plot(doorpoints(:,1),-doorpoints(:,2),'b.');
    end
    if size(windowpoints,1)>0
        plot(windowpoints(:,1),-windowpoints(:,2),'g.');
    end
    plot(wallpoints(:,1),-wallpoints(:,2),'r.');
    axis equal;
    hold off;
end
end