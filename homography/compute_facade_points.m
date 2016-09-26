function [ facade_pts,exp1,exp2 ] = compute_facade_points( map_pts,floor_num,floorplan_pts,wallcorners_all )
exp1=1;
exp2=1;
for fn=1:floor_num
    tmp=abs(floorplan_pts{fn}(1,:)-floorplan_pts{fn}(2,:));
    if tmp(1)>tmp(2)
        minnum=min(wallcorners_all{fn}(:,1));
        maxnum=max(wallcorners_all{fn}(:,1));
        num1=floorplan_pts{fn}(1,1);
        num2=floorplan_pts{fn}(2,1);
    else
        minnum=min(wallcorners_all{fn}(:,2));
        maxnum=max(wallcorners_all{fn}(:,2));
        num1=floorplan_pts{fn}(1,2);
        num2=floorplan_pts{fn}(2,2);
    end
    if num1<num2
        nowexp1=(num2-minnum)/(num2-num1);
        nowexp2=(maxnum-num1)/(num2-num1);
    else
        nowexp2=(num1-minnum)/(num1-num2);
        nowexp1=(maxnum-num2)/(num1-num2);
    end
    if nowexp1>exp1
        exp1=nowexp1;
    end
    if nowexp2>exp2
        exp2=nowexp2;
    end
end
facade_pts(1,1:2)=map_pts(2,1:2)+(map_pts(1,1:2)-map_pts(2,1:2))*exp1;
facade_pts(2,1:2)=map_pts(1,1:2)+(map_pts(2,1:2)-map_pts(1,1:2))*exp2;
end