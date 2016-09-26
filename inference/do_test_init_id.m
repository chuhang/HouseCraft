function [ testresult,testerr,optimalid ] = do_test_init_id( houseid )
load('../determine_dimensions/houseidlist.mat');
findhouse=find(houseidlist==houseid);
findhouse=findhouse(1);
testfold=mod(findhouse,6);
%-----step 1: load gt
cd ../rent_crawler/goodhouses/house74
testsz=0;
for ii=findhouse:findhouse
    if mod(ii,6)==testfold
        testsz=testsz+1;
        houseid=houseidlist(ii);
        cd(['../house',int2str(houseid)]);
        load('groundtruth_data.mat');
        testCH(testsz,1)=gtCH;
        testFH(testsz,1)=gtFH;
        testDH(testsz,1)=gtDH;
        testWB(testsz,1)=gtWB;
        testWT(testsz,1)=gtWT;
        testXY(testsz,1:2)=gtXY;
    end
end
cd ../../../inference

%-----step 3: enumerate configurations
cd ../determine_dimensions
load(['dimensions_testfold',int2str(testfold),'.mat']);
cd ../homography
[ test_building_configurations ] = enumerate_solution_relative( 40,40,CH_centers,FH_centers,DH_centers,WB_centers,WT_centers,0,0,0,0,0 );
cd ../inference

%-----step x: load weights
load(['w',int2str(testfold),'.mat']);

%-----step 6: testing
testsz=0;
for ii=findhouse:findhouse
    if mod(ii,6)==testfold
        testsz=testsz+1;
        load(['../efficient_render_and_feature/final_feature_init/id',int2str(ii),'.mat']);
        score=final_features_allviews*(w)';
        tmpids=find(score==max(score));
        tmpconfigs=test_building_configurations(tmpids,:);
        locerrsXY=[tmpconfigs(:,1)-testXY(testsz,1),tmpconfigs(:,2)-testXY(testsz,2)];
        locerrs=sqrt(locerrsXY(:,1).*locerrsXY(:,1)+locerrsXY(:,2).*locerrsXY(:,2));
        tmptmpid=find(locerrs==min(locerrs));
        tmptmpid=tmptmpid(1);
        testresultid=tmpids(tmptmpid);
        optimalid(testsz,1)=testresultid;
        testresult(testsz,1:2)=test_building_configurations(testresultid,1:2);
        testresult(testsz,3:7)=test_building_configurations(testresultid,3:7);
        testerr(testsz,1:7)=testresult(testsz,1:7)-[testXY(testsz,:),testCH(testsz,1),testFH(testsz,1),testDH(testsz,1),testWB(testsz,1),testWT(testsz,1)];
        if testDH(testsz,1)<0
            testerr(testsz,5)=0;
        end
        if testWB(testsz,1)<0
            testerr(testsz,6:7)=0;
        end
    end
end
end