function [ newimg ] = plot_on_img( img,xs,ys,color )
xs=round(xs);
ys=round(ys);
xmax=size(img,2);
ymax=size(img,1);

idx1=(xs>=1);idx2=(xs<xmax);
idx3=(ys>=1);idx4=(ys<ymax);
idx=(idx1&idx2&idx3&idx4);
newxs=xs(idx);newys=ys(idx);

mask=false(ymax,xmax);
tmp=sub2ind([ymax,xmax],newys,newxs);
mask(tmp)=1;
tmp=sub2ind([ymax,xmax],newys+1,newxs);
mask(tmp)=1;
tmp=sub2ind([ymax,xmax],newys,newxs+1);
mask(tmp)=1;
tmp=sub2ind([ymax,xmax],newys+1,newxs+1);
mask(tmp)=1;

rimg=img(:,:,1);gimg=img(:,:,2);bimg=img(:,:,3);
if color=='r'
    rimg(mask)=255;
end
if color=='g'
    gimg(mask)=255;
end
if color=='b'
    bimg(mask)=255;
end
if color=='y'
    rimg(mask)=255;
    gimg(mask)=255;
end
newimg=img;
newimg(:,:,1)=rimg;newimg(:,:,2)=gimg;newimg(:,:,3)=bimg;
end