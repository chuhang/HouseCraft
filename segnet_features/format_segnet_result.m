function [ segmask_sky,segmask_building,segmask_occlusion,segmask_unrelated ] = format_segnet_result( segnet_image,image,display )
segnet_label=round(double(segnet_image)/21.25);
sky=(segnet_label==0);
building=(segnet_label==1);
pole=(segnet_label==2);
roadmark=(segnet_label==3);
road=(segnet_label==4);
pavement=(segnet_label==5);
tree=(segnet_label==6);
sign=(segnet_label==7);
fence=(segnet_label==8);
car=(segnet_label==9);
pedestrain=(segnet_label==10);
bike=(segnet_label==11);
unlabelled=(segnet_label==12);

segmask_sky=double(sky);
segmask_building=double(building);
segmask_occlusion=double(pole|tree|sign|car);
segmask_unrelated=double(roadmark|road|pavement|fence|pedestrain|bike|unlabelled);

if display==1
    figure;
    subplot(2,2,1);
    newimg=image;
    for ii=1:3
        newimg(:,:,ii)=uint8(double(newimg(:,:,ii)).*(segmask_sky*0.8+0.2));
    end
    imshow(newimg);
    subplot(2,2,2);
    newimg=image;
    for ii=1:3
        newimg(:,:,ii)=uint8(double(newimg(:,:,ii)).*(segmask_building*0.8+0.2));
    end
    imshow(newimg);
    subplot(2,2,3);
    newimg=image;
    for ii=1:3
        newimg(:,:,ii)=uint8(double(newimg(:,:,ii)).*(segmask_occlusion*0.8+0.2));
    end
    imshow(newimg);
    subplot(2,2,4);
    newimg=image;
    for ii=1:3
        newimg(:,:,ii)=uint8(double(newimg(:,:,ii)).*(segmask_unrelated*0.8+0.2));
    end
    imshow(newimg);
end
end