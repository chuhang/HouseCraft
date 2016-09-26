function [ knnobj ] = compute_ann( transformed_image_foreground_background,rgb_or_hsv )
sample_num=5000;

if rgb_or_hsv==0
    foreground=transformed_image_foreground_background.foreground;
    background1=transformed_image_foreground_background.background1;
    background2=transformed_image_foreground_background.background2;
    background3=transformed_image_foreground_background.background3;
    background4=transformed_image_foreground_background.background4;
else
    foreground=rgb2hsv(transformed_image_foreground_background.foreground);
    background1=rgb2hsv(transformed_image_foreground_background.background1);
    background2=rgb2hsv(transformed_image_foreground_background.background2);
    background3=rgb2hsv(transformed_image_foreground_background.background3);
    background4=rgb2hsv(transformed_image_foreground_background.background4);
end

[ imgvec ] = im2vec_no_000( foreground );
forevec=imgvec;
rate=round(size(forevec,1)/sample_num);
forevec=forevec(1:rate:end,:);
backvec=[];
[ imgvec ] = im2vec_no_000( background1 );
backvec=[backvec;imgvec;];
[ imgvec ] = im2vec_no_000( background2 );
backvec=[backvec;imgvec;];
[ imgvec ] = im2vec_no_000( background3 );
backvec=[backvec;imgvec;];
[ imgvec ] = im2vec_no_000( background4 );
backvec=[backvec;imgvec;];
rate=round(size(backvec,1)/sample_num);
backvec=backvec(1:rate:end,:);
forevec=double(forevec);
backvec=double(backvec);

label=[ones(size(forevec,1),1);zeros(size(backvec,1),1)];
feature=[forevec;backvec];
cd ./ann_wrapper
anno=ann(feature');
cd ..

%determine the optimal k
cd ./ann_wrapper
[ idx,~ ] = ksearch( anno,feature',100,1,0.01 );
cd ..
reslab=label(idx);
acc=[];
for k=1:99
    resnow=sum(reslab(2:(k+1),:))/k;
    resnow=double(resnow>0.5);
    acc(k)=sum((resnow'-label)==0)/size(label,1);
end
k=find(acc==max(acc));
k=k(1);

knnobj.anno=anno;
knnobj.label=label;
knnobj.k=k;
end