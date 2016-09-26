function [ foreground_prob_image ] = compute_foreground_prob( transformed_image,knnobj,rgb_or_hsv,display )
smallimg=imresize(transformed_image,round([size(transformed_image,1),size(transformed_image,2)]/5));
if rgb_or_hsv==0
    img=smallimg;
else
    img=rgb2hsv(smallimg);
end
img=double(img);
r=img(:,:,1);g=img(:,:,2);b=img(:,:,3);
r=r(:);g=g(:);b=b(:);
data=[r,g,b];

cd ./ann_wrapper
[ idx,~ ] = ksearch( knnobj.anno,data',knnobj.k,1,0.01 );
cd ..
reslab=knnobj.label(idx);
if knnobj.k>1
    res=(sum(reslab,1)/knnobj.k)';
else
    res=reslab;
end

foreground_prob_image=reshape(res,size(smallimg,1),size(smallimg,2));
foreground_prob_image=imresize(foreground_prob_image,[size(transformed_image,1),size(transformed_image,2)]);

h=fspecial('gaussian',31,30);
foreground_prob_image=imfilter(foreground_prob_image,h);

if display==1
    figure;
    imagesc(foreground_prob_image);
end
end