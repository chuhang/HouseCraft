function [ frontalwalls ] = get_frontal_facade( walls,windows,doors,floorplan_pts_1level,display )
tmp=abs(floorplan_pts_1level(1,:)-floorplan_pts_1level(2,:));
frontalxy=(tmp(1)>tmp(2));
frontalwalls=[];
for ii=1:size(walls,1)
    tmp=abs(walls(ii,1:2)-walls(ii,3:4));
    thiswallxy=(tmp(1)>tmp(2));
    if frontalxy==thiswallxy
        frontalwalls=[frontalwalls;walls(ii,:);];
    end
end

if display==1
    figure;
    hold on;
    for ii=1:size(frontalwalls,1)
        plot([frontalwalls(ii,1);frontalwalls(ii,3)],-[frontalwalls(ii,2);frontalwalls(ii,4)],'r','LineWidth',3);
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