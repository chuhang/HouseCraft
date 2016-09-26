function [ final_features_allviews,wall_loss,window_loss,door_loss,label ] = get_final_feature_loss_1house_init( houseid )
%parameters
homography_upsample_rate=10;
gate_width_meter=3;

%-----step 1: load stored data
load(['../rent_crawler/goodhouses/house',int2str(houseid),'/goodimages.mat']);
load(['./integral_feature/house',int2str(houseid),'.mat']);
load(['./render_init/house',int2str(houseid),'.mat']);
load(['./loss_and_label/house',int2str(houseid),'.mat']);
for which=1:3
    if goodimages(which)==1
        searchsz=size(all_wallloss{which},1);
        imgsz=size(features.all_edge_dist_int{which});
        break;
    end
end

%-----step 2: features
final_features_allviews=zeros(searchsz,29);
for which=1:3
    if goodimages(which)==1
        %all lines
        edge_dist_final=zeros(searchsz,1);
        edge_thres1_final=zeros(searchsz,1);
        edge_thres2_final=zeros(searchsz,1);
        edge_thres3_final=zeros(searchsz,1);
        edge_dist_int_vec=features.all_edge_dist_int{which}(:);
        edge_thres1_int_vec=features.all_edge_thres1_int{which}(:);
        edge_thres2_int_vec=features.all_edge_thres2_int{which}(:);
        edge_thres3_int_vec=features.all_edge_thres3_int{which}(:);
        %hori lines
        edge_hori_dist_final=zeros(searchsz,1);
        edge_hori_thres1_final=zeros(searchsz,1);
        edge_hori_thres2_final=zeros(searchsz,1);
        edge_hori_thres3_final=zeros(searchsz,1);
        edge_hori_dist_int_vec=features.all_edge_hori_dist_int{which}(:);
        edge_hori_thres1_int_vec=features.all_edge_hori_thres1_int{which}(:);
        edge_hori_thres2_int_vec=features.all_edge_hori_thres2_int{which}(:);
        edge_hori_thres3_int_vec=features.all_edge_hori_thres3_int{which}(:);
        linenum=size(all_renderlinerects_homography_batched{which}.wallhori,1)/searchsz;
        xmins=reshape(all_renderlinerects_homography_batched{which}.wallhori(:,1),linenum,searchsz)';
        xmaxs=reshape(all_renderlinerects_homography_batched{which}.wallhori(:,3),linenum,searchsz)';
        ymins=reshape(all_renderlinerects_homography_batched{which}.wallhori(:,2),linenum,searchsz)';
        ymaxs=reshape(all_renderlinerects_homography_batched{which}.wallhori(:,4),linenum,searchsz)';
        xmins(xmins<2)=2;xmins(xmins>(imgsz(2)-1))=imgsz(2)-1;
        xmaxs(xmaxs<2)=2;xmaxs(xmaxs>(imgsz(2)-1))=imgsz(2)-1;
        ymins(ymins<2)=2;ymins(ymins>(imgsz(1)-1))=imgsz(1)-1;
        ymaxs(ymaxs<2)=2;ymaxs(ymaxs>(imgsz(1)-1))=imgsz(1)-1;
        for ii=1:linenum
            idx1=sub2ind(imgsz,round((ymaxs(:,ii)+ymins(:,ii))/2),xmaxs(:,ii));
            idx2=sub2ind(imgsz,round((ymaxs(:,ii)+ymins(:,ii))/2)-1,xmins(:,ii));
            idx3=sub2ind(imgsz,round((ymaxs(:,ii)+ymins(:,ii))/2)-1,xmaxs(:,ii));
            idx4=sub2ind(imgsz,round((ymaxs(:,ii)+ymins(:,ii))/2),xmins(:,ii));
            vals=edge_hori_dist_int_vec(idx1)+edge_hori_dist_int_vec(idx2)-edge_hori_dist_int_vec(idx3)-edge_hori_dist_int_vec(idx4);
            edge_hori_dist_final=edge_hori_dist_final+vals;
            vals=edge_hori_thres1_int_vec(idx1)+edge_hori_thres1_int_vec(idx2)-edge_hori_thres1_int_vec(idx3)-edge_hori_thres1_int_vec(idx4);
            edge_hori_thres1_final=edge_hori_thres1_final+vals;
            vals=edge_hori_thres2_int_vec(idx1)+edge_hori_thres2_int_vec(idx2)-edge_hori_thres2_int_vec(idx3)-edge_hori_thres2_int_vec(idx4);
            edge_hori_thres2_final=edge_hori_thres2_final+vals;
            vals=edge_hori_thres3_int_vec(idx1)+edge_hori_thres3_int_vec(idx2)-edge_hori_thres3_int_vec(idx3)-edge_hori_thres3_int_vec(idx4);
            edge_hori_thres3_final=edge_hori_thres3_final+vals;
            vals=edge_dist_int_vec(idx1)+edge_dist_int_vec(idx2)-edge_dist_int_vec(idx3)-edge_dist_int_vec(idx4);
            edge_dist_final=edge_dist_final+vals;
            vals=edge_thres1_int_vec(idx1)+edge_thres1_int_vec(idx2)-edge_thres1_int_vec(idx3)-edge_thres1_int_vec(idx4);
            edge_thres1_final=edge_thres1_final+vals;
            vals=edge_thres2_int_vec(idx1)+edge_thres2_int_vec(idx2)-edge_thres2_int_vec(idx3)-edge_thres2_int_vec(idx4);
            edge_thres2_final=edge_thres2_final+vals;
            vals=edge_thres3_int_vec(idx1)+edge_thres3_int_vec(idx2)-edge_thres3_int_vec(idx3)-edge_thres3_int_vec(idx4);
            edge_thres3_final=edge_thres3_final+vals;
        end
        %vert lines
        edge_vert_dist_final=zeros(searchsz,1);
        edge_vert_thres1_final=zeros(searchsz,1);
        edge_vert_thres2_final=zeros(searchsz,1);
        edge_vert_thres3_final=zeros(searchsz,1);
        edge_vert_dist_int_vec=features.all_edge_vert_dist_int{which}(:);
        edge_vert_thres1_int_vec=features.all_edge_vert_thres1_int{which}(:);
        edge_vert_thres2_int_vec=features.all_edge_vert_thres2_int{which}(:);
        edge_vert_thres3_int_vec=features.all_edge_vert_thres3_int{which}(:);
        linenum=size(all_renderlinerects_homography_batched{which}.wallvert,1)/searchsz;
        xmins=reshape(all_renderlinerects_homography_batched{which}.wallvert(:,1),linenum,searchsz)';
        xmaxs=reshape(all_renderlinerects_homography_batched{which}.wallvert(:,3),linenum,searchsz)';
        ymins=reshape(all_renderlinerects_homography_batched{which}.wallvert(:,2),linenum,searchsz)';
        ymaxs=reshape(all_renderlinerects_homography_batched{which}.wallvert(:,4),linenum,searchsz)';
        xmins(xmins<2)=2;xmins(xmins>(imgsz(2)-1))=imgsz(2)-1;
        xmaxs(xmaxs<2)=2;xmaxs(xmaxs>(imgsz(2)-1))=imgsz(2)-1;
        ymins(ymins<2)=2;ymins(ymins>(imgsz(1)-1))=imgsz(1)-1;
        ymaxs(ymaxs<2)=2;ymaxs(ymaxs>(imgsz(1)-1))=imgsz(1)-1;
        for ii=1:linenum
            idx1=sub2ind(imgsz,ymaxs(:,ii),round((xmaxs(:,ii)+xmins(:,ii))/2));
            idx2=sub2ind(imgsz,ymins(:,ii),round((xmaxs(:,ii)+xmins(:,ii))/2)-1);
            idx3=sub2ind(imgsz,ymins(:,ii),round((xmaxs(:,ii)+xmins(:,ii))/2));
            idx4=sub2ind(imgsz,ymaxs(:,ii),round((xmaxs(:,ii)+xmins(:,ii))/2)-1);
            vals=edge_vert_dist_int_vec(idx1)+edge_vert_dist_int_vec(idx2)-edge_vert_dist_int_vec(idx3)-edge_vert_dist_int_vec(idx4);
            edge_vert_dist_final=edge_vert_dist_final+vals;
            vals=edge_vert_thres1_int_vec(idx1)+edge_vert_thres1_int_vec(idx2)-edge_vert_thres1_int_vec(idx3)-edge_vert_thres1_int_vec(idx4);
            edge_vert_thres1_final=edge_vert_thres1_final+vals;
            vals=edge_vert_thres2_int_vec(idx1)+edge_vert_thres2_int_vec(idx2)-edge_vert_thres2_int_vec(idx3)-edge_vert_thres2_int_vec(idx4);
            edge_vert_thres2_final=edge_vert_thres2_final+vals;
            vals=edge_vert_thres3_int_vec(idx1)+edge_vert_thres3_int_vec(idx2)-edge_vert_thres3_int_vec(idx3)-edge_vert_thres3_int_vec(idx4);
            edge_vert_thres3_final=edge_vert_thres3_final+vals;
            vals=edge_dist_int_vec(idx1)+edge_dist_int_vec(idx2)-edge_dist_int_vec(idx3)-edge_dist_int_vec(idx4);
            edge_dist_final=edge_dist_final+vals;
            vals=edge_thres1_int_vec(idx1)+edge_thres1_int_vec(idx2)-edge_thres1_int_vec(idx3)-edge_thres1_int_vec(idx4);
            edge_thres1_final=edge_thres1_final+vals;
            vals=edge_thres2_int_vec(idx1)+edge_thres2_int_vec(idx2)-edge_thres2_int_vec(idx3)-edge_thres2_int_vec(idx4);
            edge_thres2_final=edge_thres2_final+vals;
            vals=edge_thres3_int_vec(idx1)+edge_thres3_int_vec(idx2)-edge_thres3_int_vec(idx3)-edge_thres3_int_vec(idx4);
            edge_thres3_final=edge_thres3_final+vals;
        end
        %window features
        window_in_final=zeros(searchsz,1);
        window_out_rendered_final=zeros(searchsz,1);
        window_out_detected_final=zeros(searchsz,1);
        window_detectionimg_int_vec=features.all_window_detectionimg_int{which}(:);
        windownum=size(all_renderlinerects_homography_batched{which}.window,1)/searchsz;
        if windownum>0
            xmins=reshape(all_renderlinerects_homography_batched{which}.window(:,1),windownum,searchsz)';
            xmaxs=reshape(all_renderlinerects_homography_batched{which}.window(:,3),windownum,searchsz)';
            ymins=reshape(all_renderlinerects_homography_batched{which}.window(:,2),windownum,searchsz)';
            ymaxs=reshape(all_renderlinerects_homography_batched{which}.window(:,4),windownum,searchsz)';
            xmins(xmins<2)=2;xmins(xmins>(imgsz(2)-1))=imgsz(2)-1;
            xmaxs(xmaxs<2)=2;xmaxs(xmaxs>(imgsz(2)-1))=imgsz(2)-1;
            ymins(ymins<2)=2;ymins(ymins>(imgsz(1)-1))=imgsz(1)-1;
            ymaxs(ymaxs<2)=2;ymaxs(ymaxs>(imgsz(1)-1))=imgsz(1)-1;        
            for ii=1:windownum
                idx1=sub2ind(imgsz,ymaxs(:,ii),xmaxs(:,ii));
                idx2=sub2ind(imgsz,ymins(:,ii),xmins(:,ii));
                idx3=sub2ind(imgsz,ymins(:,ii),xmaxs(:,ii));
                idx4=sub2ind(imgsz,ymaxs(:,ii),xmins(:,ii));
                vals=window_detectionimg_int_vec(idx1)+window_detectionimg_int_vec(idx2)-window_detectionimg_int_vec(idx3)-window_detectionimg_int_vec(idx4);
                window_in_final=window_in_final+vals;
                window_out_rendered_final=window_out_rendered_final+(xmaxs(:,ii)-xmins(:,ii)).*(ymaxs(:,ii)-ymins(:,ii));
            end
            window_out_rendered_final=window_out_rendered_final-window_in_final;
            window_out_detected_final=ones(searchsz,1)*window_detectionimg_int_vec(end)-window_in_final;
        end
        %gate and door features
        door_in_final=zeros(searchsz,1);
        door_out_rendered_final=zeros(searchsz,1);
        door_out_detected_final=zeros(searchsz,1);
        gate_in_final=zeros(searchsz,1);
        gate_out_rendered_final=zeros(searchsz,1);
        gate_out_detected_final=zeros(searchsz,1);
        door_detectionimg_int_vec=features.all_door_detectionimg_int{which}(:);
        gate_detectionimg_int_vec=features.all_gate_detectionimg_int{which}(:);
        doornum=size(all_renderlinerects_homography_batched{which}.door,1)/searchsz;
        if doornum>0
            xmins=reshape(all_renderlinerects_homography_batched{which}.door(:,1),doornum,searchsz)';
            xmaxs=reshape(all_renderlinerects_homography_batched{which}.door(:,3),doornum,searchsz)';
            ymins=reshape(all_renderlinerects_homography_batched{which}.door(:,2),doornum,searchsz)';
            ymaxs=reshape(all_renderlinerects_homography_batched{which}.door(:,4),doornum,searchsz)';
            doorwidth=xmaxs(5072,:)-xmins(5072,:);
            isgate=(doorwidth>(homography_upsample_rate*gate_width_meter*4));
            xmins(xmins<2)=2;xmins(xmins>(imgsz(2)-1))=imgsz(2)-1;
            xmaxs(xmaxs<2)=2;xmaxs(xmaxs>(imgsz(2)-1))=imgsz(2)-1;
            ymins(ymins<2)=2;ymins(ymins>(imgsz(1)-1))=imgsz(1)-1;
            ymaxs(ymaxs<2)=2;ymaxs(ymaxs>(imgsz(1)-1))=imgsz(1)-1;        
            for ii=1:doornum
                if isgate(ii)==1
                    idx1=sub2ind(imgsz,ymaxs(:,ii),xmaxs(:,ii));
                    idx2=sub2ind(imgsz,ymins(:,ii),xmins(:,ii));
                    idx3=sub2ind(imgsz,ymins(:,ii),xmaxs(:,ii));
                    idx4=sub2ind(imgsz,ymaxs(:,ii),xmins(:,ii));
                    vals=gate_detectionimg_int_vec(idx1)+gate_detectionimg_int_vec(idx2)-gate_detectionimg_int_vec(idx3)-gate_detectionimg_int_vec(idx4);
                    gate_in_final=gate_in_final+vals;
                    gate_out_rendered_final=gate_out_rendered_final+(xmaxs(:,ii)-xmins(:,ii)).*(ymaxs(:,ii)-ymins(:,ii));
                else
                    idx1=sub2ind(imgsz,ymaxs(:,ii),xmaxs(:,ii));
                    idx2=sub2ind(imgsz,ymins(:,ii),xmins(:,ii));
                    idx3=sub2ind(imgsz,ymins(:,ii),xmaxs(:,ii));
                    idx4=sub2ind(imgsz,ymaxs(:,ii),xmins(:,ii));
                    vals=door_detectionimg_int_vec(idx1)+door_detectionimg_int_vec(idx2)-door_detectionimg_int_vec(idx3)-door_detectionimg_int_vec(idx4);
                    door_in_final=door_in_final+vals;
                    door_out_rendered_final=door_out_rendered_final+(xmaxs(:,ii)-xmins(:,ii)).*(ymaxs(:,ii)-ymins(:,ii));
                end
            end
            gate_out_rendered_final=gate_out_rendered_final-gate_in_final;
            gate_out_detected_final=ones(searchsz,1)*gate_detectionimg_int_vec(end)-gate_in_final;
            door_out_rendered_final=door_out_rendered_final-door_in_final;
            door_out_detected_final=ones(searchsz,1)*door_detectionimg_int_vec(end)-door_in_final;
        end
        %compute whole building masks
        allpointsx=[];
        data=all_renderlinerects_homography_batched{which}.wallhori(:,1);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsx=[allpointsx,data'];
        data=all_renderlinerects_homography_batched{which}.wallhori(:,3);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsx=[allpointsx,data'];
        data=all_renderlinerects_homography_batched{which}.wallvert(:,1);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsx=[allpointsx,data'];
        data=all_renderlinerects_homography_batched{which}.wallvert(:,3);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsx=[allpointsx,data'];
        allpointsy=[];
        data=all_renderlinerects_homography_batched{which}.wallhori(:,2);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsy=[allpointsy,data'];
        data=all_renderlinerects_homography_batched{which}.wallhori(:,4);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsy=[allpointsy,data'];
        data=all_renderlinerects_homography_batched{which}.wallvert(:,2);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsy=[allpointsy,data'];
        data=all_renderlinerects_homography_batched{which}.wallvert(:,4);
        data=reshape(data,size(data,1)/searchsz,searchsz);
        allpointsy=[allpointsy,data'];
        xmins=min(allpointsx')';
        xmaxs=max(allpointsx')';
        ymins=min(allpointsy')';
        ymaxs=max(allpointsy')';
        xmins(xmins<2)=2;xmins(xmins>(imgsz(2)-1))=imgsz(2)-1;
        xmaxs(xmaxs<2)=2;xmaxs(xmaxs>(imgsz(2)-1))=imgsz(2)-1;
        ymins(ymins<2)=2;ymins(ymins>(imgsz(1)-1))=imgsz(1)-1;
        ymaxs(ymaxs<2)=2;ymaxs(ymaxs>(imgsz(1)-1))=imgsz(1)-1;
        idx1=sub2ind(imgsz,ymaxs,xmaxs);
        idx2=sub2ind(imgsz,ymins,xmins);
        idx3=sub2ind(imgsz,ymins,xmaxs);
        idx4=sub2ind(imgsz,ymaxs,xmins);
        %saliency features
        mbs_image_int_vec=features.all_mbs_image_int{which}(:);
        mbs_final=mbs_image_int_vec(idx1)+mbs_image_int_vec(idx2)-mbs_image_int_vec(idx3)-mbs_image_int_vec(idx4);
        mbs_plus_image_int_vec=features.all_mbs_plus_image_int{which}(:);
        mbs_plus_final=mbs_plus_image_int_vec(idx1)+mbs_plus_image_int_vec(idx2)-mbs_plus_image_int_vec(idx3)-mbs_plus_image_int_vec(idx4);
        %foreground features
        foreground_prob_rgb_int_vec=features.all_foreground_prob_rgb_int{which}(:);
        foreground_prob_rgb_final=foreground_prob_rgb_int_vec(idx1)+foreground_prob_rgb_int_vec(idx2)-foreground_prob_rgb_int_vec(idx3)-foreground_prob_rgb_int_vec(idx4);
        foreground_prob_hsv_int_vec=features.all_foreground_prob_hsv_int{which}(:);
        foreground_prob_hsv_final=foreground_prob_hsv_int_vec(idx1)+foreground_prob_hsv_int_vec(idx2)-foreground_prob_hsv_int_vec(idx3)-foreground_prob_hsv_int_vec(idx4);
        %segnet features
        segmask_sky_int_vec=features.all_segmask_sky_int{which}(:);
        segmask_sky_final=segmask_sky_int_vec(idx1)+segmask_sky_int_vec(idx2)-segmask_sky_int_vec(idx3)-segmask_sky_int_vec(idx4);
        segmask_building_int_vec=features.all_segmask_building_int{which}(:);
        segmask_building_final=segmask_building_int_vec(idx1)+segmask_building_int_vec(idx2)-segmask_building_int_vec(idx3)-segmask_building_int_vec(idx4);
        segmask_occlusion_int_vec=features.all_segmask_occlusion_int{which}(:);
        segmask_occlusion_final=segmask_occlusion_int_vec(idx1)+segmask_occlusion_int_vec(idx2)-segmask_occlusion_int_vec(idx3)-segmask_occlusion_int_vec(idx4);
        segmask_unrelated_int_vec=features.all_segmask_sky_unrelated{which}(:);
        segmask_unrelated_final=segmask_unrelated_int_vec(idx1)+segmask_unrelated_int_vec(idx2)-segmask_unrelated_int_vec(idx3)-segmask_unrelated_int_vec(idx4);
        %final features
        final_features=[edge_dist_final,edge_thres1_final,edge_thres2_final,edge_thres3_final,edge_hori_dist_final,edge_hori_thres1_final,edge_hori_thres2_final,edge_hori_thres3_final,edge_vert_dist_final,edge_vert_thres1_final,edge_vert_thres2_final,edge_vert_thres3_final];
        final_features=[final_features,window_in_final,window_out_rendered_final,window_out_detected_final,gate_in_final,gate_out_rendered_final,gate_out_detected_final,door_in_final,door_out_rendered_final,door_out_detected_final];
        final_features=[final_features,mbs_final,mbs_plus_final,foreground_prob_rgb_final,foreground_prob_hsv_final,segmask_sky_final,segmask_building_final,segmask_occlusion_final,segmask_unrelated_final];
        %normalize features
        for ii=1:29
            if std(final_features(:,ii))>0.00001
                final_features(:,ii)=(final_features(:,ii)-mean(final_features(:,ii)))/std(final_features(:,ii));
            end
        end
        final_features_allviews=final_features_allviews+final_features;
    end
end
final_features_allviews=final_features_allviews/sum(goodimages);

%-----step 3: loss
wall_loss=zeros(searchsz,1);
window_loss=zeros(searchsz,1);
door_loss=zeros(searchsz,1);
for which=1:3
    if goodimages(which)==1
        wall_loss=wall_loss+all_wallloss{which};
        window_loss=window_loss+all_windowloss{which};
        door_loss=door_loss+all_doorloss{which};
    end
end
wall_loss=wall_loss/sum(goodimages);
window_loss=window_loss/sum(goodimages);
door_loss=door_loss/sum(goodimages);
end