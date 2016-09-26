%-----step 1: compute all the renders, integral feature maps, and losses
%-----(for inference losses are not needed)
disp('step 1: compute all the renders, integral features, and losses');
cd ./determine_dimensions
load('houseidlist.mat');
cd ../efficient_render_and_feature
for ii=52:52
    tic;
    houseid=houseidlist(ii);
    disp(['processing house #',int2str(houseid)]);
    [ all_img_data,all_renderlinerects_homography_batched,all_transformed_image,all_renderlinerects_homography,goodimages,all_foreground_prob_rgb,all_foreground_prob_hsv,all_tform,all_wallloss,all_windowloss,all_doorloss,label ] = efficient_render_init( houseid,0 );
    t=toc;
    disp(['Processing time: ',num2str(t),' seconds.']);
    [ features ] = integral_feature( houseid,all_transformed_image,all_tform,goodimages,all_foreground_prob_rgb,all_foreground_prob_hsv );
    % save intermediate files for easier debugging, though it takes lots of space and time
    save(['./loss_and_label/house',int2str(houseid),'.mat'],'all_wallloss','all_windowloss','all_doorloss','label');
    save(['./integral_feature/house',int2str(houseid),'.mat'],'features');
    save(['./render_init/house',int2str(houseid),'.mat'],'all_renderlinerects_homography_batched');
    clear all_wallloss all_windowloss all_doorloss features all_renderlinerects_homography_batched
end
cd ..
clear
%-----step 2: compute all the final feature
disp('step 2: compute all the final feature');
cd ./determine_dimensions
load('houseidlist.mat');
cd ../efficient_render_and_feature
for ii=52:52
    tic;
    houseid=houseidlist(ii);
    disp(['processing house #',int2str(houseid)]);
    [ final_features_allviews,wall_loss,window_loss,door_loss,label ] = get_final_feature_loss_1house_init( houseid );
    t=toc;
    disp(['Processing time: ',num2str(t),' seconds.']);
    % save intermediate files for easier debugging, though it takes lots of space and time
    save(['./final_feature_init/id',int2str(ii),'.mat'],'final_features_allviews');
end
clear
cd ..
%-----step 3: inference
disp('step 3: inference');
cd ./determine_dimensions
load('houseidlist.mat');
cd ../inference
for ii=52:52
    tic;
    houseid=houseidlist(ii);
    disp(['processing house #',int2str(houseid)]);
    [ testresult,testerr,optimalid ] = do_test_init_id( houseid );
    allresults(ii,1:7)=testresult;
    t=toc;
    % this time is not accurate since it includes reading intermediate
    % file, which shouldn't be taken into account
    disp(['Processing time: ',num2str(t),' seconds.']);
end
cd ..
%-----step 4: visualize
disp('step 4: visualize')
cd ./final_visualization
for ii=52:52
    houseid=houseidlist(ii);
    visualize_1house( houseid,allresults(ii,:),1,1 );
end
cd ..