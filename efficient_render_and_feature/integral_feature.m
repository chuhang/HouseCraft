function [ features ] = integral_feature( houseid,all_transformed_image,all_tform,goodimages,all_foreground_prob_rgb,all_foreground_prob_hsv )
%-----parameters
edge_thresholds=[4,8,16]; %correspond to [0.1,0.2,0.4] meters when homography_upsample_rate = 10;

%-----step 1: edge features
cd ../scoring
for which=1:3
    if goodimages(which)==1
        [ edge_dist,edge_vert_dist,edge_hori_dist ] = prepare_S_edge_hori( all_transformed_image{which} );
        all_edge_dist{which}=edge_dist;
        all_edge_vert_dist{which}=edge_vert_dist;
        all_edge_hori_dist{which}=edge_hori_dist;
    else
        all_edge_dist{which}=[];
        all_edge_vert_dist{which}=[];
        all_edge_hori_dist{which}=[];
    end
end

%-----step 2: door/window detection features
cd ../cnn_detection
load(['./detection_results/house',int2str(houseid),'.mat']);
for which=1:3
    if goodimages(which)==1
        window_detectionimg=zeros(size(all_transformed_image{which},1),size(all_transformed_image{which},2));
        nowboxes=all_detected_windows{which};
        for jj=1:size(nowboxes,1)
            xmin=round(nowboxes(jj,1));xmax=round(nowboxes(jj,1)+nowboxes(jj,3));
            ymin=round(nowboxes(jj,2));ymax=round(nowboxes(jj,2)+nowboxes(jj,4));
            prob=1;%prob=nowboxes(jj,5);
            window_detectionimg(ymin:ymax,xmin:xmax)=prob;
        end
        door_detectionimg=zeros(size(all_transformed_image{which},1),size(all_transformed_image{which},2));
        nowboxes=all_detected_doors{which};
        for jj=1:size(nowboxes,1)
            xmin=round(nowboxes(jj,1));xmax=round(nowboxes(jj,1)+nowboxes(jj,3));
            ymin=round(nowboxes(jj,2));ymax=round(nowboxes(jj,2)+nowboxes(jj,4));
            prob=1;%prob=nowboxes(jj,5);
            door_detectionimg(ymin:ymax,xmin:xmax)=prob;
        end
        gate_detectionimg=zeros(size(all_transformed_image{which},1),size(all_transformed_image{which},2));
        nowboxes=all_detected_gates{which};
        for jj=1:size(nowboxes,1)
            xmin=round(nowboxes(jj,1));xmax=round(nowboxes(jj,1)+nowboxes(jj,3));
            ymin=round(nowboxes(jj,2));ymax=round(nowboxes(jj,2)+nowboxes(jj,4));
            prob=1;%prob=nowboxes(jj,5);
            gate_detectionimg(ymin:ymax,xmin:xmax)=prob;
        end
        all_window_detectionimg{which}=window_detectionimg;
        all_door_detectionimg{which}=door_detectionimg;
        all_gate_detectionimg{which}=gate_detectionimg;
    else
        all_window_detectionimg{which}=[];
        all_door_detectionimg{which}=[];
        all_gate_detectionimg{which}=[];
    end
end

%-----step 3: compute saliency
cd ../mbs_saliency
for which=1:3
    if goodimages(which)==1
        tmp=imread(['./precomputed_output/transformed_house',int2str(houseid),'view',int2str(which),'_MB.png']);
        all_mbs_image{which}=tmp;
        tmp=imread(['./precomputed_output/transformed_house',int2str(houseid),'view',int2str(which),'_MB+.png']);
        all_mbs_plus_image{which}=tmp;
    else
        all_mbs_image{which}=[];
        all_mbs_plus_image{which}=[];
    end
end

%-----step 4: compute color-based foreground score
%done in efficient_render, extra step 1

%-----step 5: segnet features
cd ../segnet_features
for which=1:3
    if goodimages(which)==1
        tmp=imread(['./image_segnet_result/house',int2str(houseid),'view',int2str(which),'.png']);
        transformed_segnet=imtransform(tmp,all_tform{which},'XData',[1,size(all_transformed_image{which},2)],'YData',[1,size(all_transformed_image{which},1)]);
        all_segnet_image{which}=transformed_segnet;
        tmp=imread(['./transformed_image_segnet_result/transformed_house',int2str(houseid),'view',int2str(which),'.png']);
        all_transformed_segnet_image{which}=tmp;
    else
        all_segnet_image{which}=[];
        all_transformed_segnet_image{which}=[];
    end
end
for which=1:3
    if goodimages(which)==1
        [ segmask_sky,segmask_building,segmask_occlusion,segmask_unrelated ] = format_segnet_result( all_segnet_image{which},all_transformed_image{which},0 );
        all_segmask_sky{which}=segmask_sky;all_segmask_building{which}=segmask_building;all_segmask_occlusion{which}=segmask_occlusion;all_segmask_unrelated{which}=segmask_unrelated;
        [ segmask_sky,segmask_building,segmask_occlusion,segmask_unrelated ] = format_segnet_result( all_transformed_segnet_image{which},all_transformed_image{which},0 );
        all_transformed_segmask_sky{which}=segmask_sky;all_transformed_segmask_building{which}=segmask_building;all_transformed_segmask_occlusion{which}=segmask_occlusion;all_transformed_segmask_unrelated{which}=segmask_unrelated;
    else
        all_segmask_sky{which}=[];all_segmask_building{which}=[];all_segmask_occlusion{which}=[];all_segmask_unrelated{which}=[];
        all_transformed_segmask_sky{which}=[];all_transformed_segmask_building{which}=[];all_transformed_segmask_occlusion{which}=[];all_transformed_segmask_unrelated{which}=[];
    end
end

%-----step 6: make all images integral
cd ../efficient_render_and_feature
for which=1:3
    if goodimages(which)==1
        %6.1 for edge
        tmp=integralImage(all_edge_dist{which});tmp=tmp(2:end,2:end);
        all_edge_dist_int{which}=tmp;
        tmp=double(all_edge_dist{which}<edge_thresholds(1));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_thres1_int{which}=tmp;
        tmp=double(all_edge_dist{which}<edge_thresholds(2));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_thres2_int{which}=tmp;
        tmp=double(all_edge_dist{which}<edge_thresholds(3));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_thres3_int{which}=tmp;        
        tmp=integralImage(all_edge_vert_dist{which});tmp=tmp(2:end,2:end);
        all_edge_vert_dist_int{which}=tmp;
        tmp=double(all_edge_vert_dist{which}<edge_thresholds(1));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_vert_thres1_int{which}=tmp;
        tmp=double(all_edge_vert_dist{which}<edge_thresholds(2));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_vert_thres2_int{which}=tmp;
        tmp=double(all_edge_vert_dist{which}<edge_thresholds(3));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_vert_thres3_int{which}=tmp;        
        tmp=integralImage(all_edge_hori_dist{which});tmp=tmp(2:end,2:end);
        all_edge_hori_dist_int{which}=tmp;
        tmp=double(all_edge_hori_dist{which}<edge_thresholds(1));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_hori_thres1_int{which}=tmp;
        tmp=double(all_edge_hori_dist{which}<edge_thresholds(2));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_hori_thres2_int{which}=tmp;
        tmp=double(all_edge_hori_dist{which}<edge_thresholds(3));
        tmp=integralImage(tmp);tmp=tmp(2:end,2:end);
        all_edge_hori_thres3_int{which}=tmp;
        
        %6.2 for detection
        tmp=integralImage(all_window_detectionimg{which});tmp=tmp(2:end,2:end);
        all_window_detectionimg_int{which}=tmp;
        tmp=integralImage(all_door_detectionimg{which});tmp=tmp(2:end,2:end);
        all_door_detectionimg_int{which}=tmp;
        tmp=integralImage(all_gate_detectionimg{which});tmp=tmp(2:end,2:end);
        all_gate_detectionimg_int{which}=tmp;
        
        %6.3 for saliency
        tmp=integralImage(all_mbs_image{which});tmp=tmp(2:end,2:end);
        all_mbs_image_int{which}=tmp;
        tmp=integralImage(all_mbs_plus_image{which});tmp=tmp(2:end,2:end);
        all_mbs_plus_image_int{which}=tmp;
        
        %6.4 for foreground
        tmp=integralImage(all_foreground_prob_rgb{which});tmp=tmp(2:end,2:end);
        all_foreground_prob_rgb_int{which}=tmp;
        tmp=integralImage(all_foreground_prob_hsv{which});tmp=tmp(2:end,2:end);
        all_foreground_prob_hsv_int{which}=tmp;
        
        %6.5 for segnet
        tmp=integralImage(all_segmask_sky{which});tmp=tmp(2:end,2:end);
        all_segmask_sky_int{which}=tmp;
        tmp=integralImage(all_segmask_building{which});tmp=tmp(2:end,2:end);
        all_segmask_building_int{which}=tmp;
        tmp=integralImage(all_segmask_occlusion{which});tmp=tmp(2:end,2:end);
        all_segmask_occlusion_int{which}=tmp;
        tmp=integralImage(all_segmask_unrelated{which});tmp=tmp(2:end,2:end);
        all_segmask_sky_unrelated{which}=tmp;%typo! but just keep it that way!
        
    else
        all_edge_dist_int{which}=[];
        all_edge_thres1_int{which}=[];
        all_edge_thres2_int{which}=[];
        all_edge_thres3_int{which}=[];
        all_edge_vert_dist_int{which}=[];
        all_edge_vert_thres1_int{which}=[];
        all_edge_vert_thres2_int{which}=[];
        all_edge_vert_thres3_int{which}=[];
        all_edge_hori_dist_int{which}=[];
        all_edge_hori_thres1_int{which}=[];
        all_edge_hori_thres2_int{which}=[];
        all_edge_hori_thres3_int{which}=[];
        all_window_detectionimg_int{which}=[];
        all_door_detectionimg_int{which}=[];
        all_gate_detectionimg_int{which}=[];
        all_mbs_image_int{which}=[];
        all_mbs_plus_image_int{which}=[];
        all_foreground_prob_rgb_int{which}=[];
        all_foreground_prob_hsv_int{which}=[];
        all_segmask_sky_int{which}=[];
        all_segmask_building_int{which}=[];
        all_segmask_occlusion_int{which}=[];
        all_segmask_sky_unrelated{which}=[];
    end
end

features.all_edge_dist_int=all_edge_dist_int;
features.all_edge_thres1_int=all_edge_thres1_int;
features.all_edge_thres2_int=all_edge_thres2_int;
features.all_edge_thres3_int=all_edge_thres3_int;
features.all_edge_vert_dist_int=all_edge_vert_dist_int;
features.all_edge_vert_thres1_int=all_edge_vert_thres1_int;
features.all_edge_vert_thres2_int=all_edge_vert_thres2_int;
features.all_edge_vert_thres3_int=all_edge_vert_thres3_int;
features.all_edge_hori_dist_int=all_edge_hori_dist_int;
features.all_edge_hori_thres1_int=all_edge_hori_thres1_int;
features.all_edge_hori_thres2_int=all_edge_hori_thres2_int;
features.all_edge_hori_thres3_int=all_edge_hori_thres3_int;
features.all_window_detectionimg_int=all_window_detectionimg_int;
features.all_door_detectionimg_int=all_door_detectionimg_int;
features.all_gate_detectionimg_int=all_gate_detectionimg_int;
features.all_mbs_image_int=all_mbs_image_int;
features.all_mbs_plus_image_int=all_mbs_plus_image_int;
features.all_foreground_prob_rgb_int=all_foreground_prob_rgb_int;
features.all_foreground_prob_hsv_int=all_foreground_prob_hsv_int;
features.all_segmask_sky_int=all_segmask_sky_int;
features.all_segmask_building_int=all_segmask_building_int;
features.all_segmask_occlusion_int=all_segmask_occlusion_int;
features.all_segmask_sky_unrelated=all_segmask_sky_unrelated;
        
% cd back to original folder
end