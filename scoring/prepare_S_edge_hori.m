function [ edge_dist,edge_vert_dist,edge_hori_dist ] = prepare_S_edge_hori( transformed_image )
%compute edge potential
cd ../asset_detector/edges
load('./models/forest/modelBsds.mat');
addpath(genpath('./toolbox'))
[edge_mag,edge_orien,~,~]=edgesDetect(transformed_image,model);
level=graythresh(edge_mag);
edge_bin=im2bw(edge_mag,level);
edge_bin_orien=edge_orien.*edge_bin;
edge_dist=bwdist(edge_bin);

edge_vert=((edge_bin_orien>(pi*8/9))|((edge_bin_orien<(pi/9))&edge_bin));
se=strel([0,1,0;0,1,0;0,1,0;]);
for ii=1:8
    edge_vert=imerode(edge_vert,se);
end
for ii=1:8
    edge_vert=imdilate(edge_vert,se);
end
edge_vert_dist=bwdist(edge_vert);

edge_hori=((edge_bin_orien>(pi*7/18))&((edge_bin_orien<(pi*11/18))));
se=strel([0,0,0;1,1,1;0,0,0;]);
for ii=1:8
    edge_hori=imerode(edge_hori,se);
end
for ii=1:8
    edge_hori=imdilate(edge_hori,se);
end
edge_hori_dist=bwdist(edge_hori);
cd ../../scoring
end