function [ imgvec ] = im2vec_no_000( img )
r=img(:,:,1);g=img(:,:,2);b=img(:,:,3);
r=r(:);g=g(:);b=b(:);
id1=(r>0);id2=(g>0);id3=(b>0);
idx=(id1&id2&id3);
imgvec=[r(idx),g(idx),b(idx)];
end