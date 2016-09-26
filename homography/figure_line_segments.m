function [ lines ] = figure_line_segments( canvas_img,hori_vert )
binimg=canvas_img(:,:,2);

se=strel('square',3);
binimg=(binimg==255);
for ii=1:7
    binimg=imdilate(binimg,se);
end
for ii=1:6
    binimg=imerode(binimg,se);
end

CC=bwconncomp(binimg);
lines=[];
for ii=1:length(CC.PixelIdxList)
    if length(CC.PixelIdxList{ii})>20
        [ys,xs]=ind2sub(size(binimg),CC.PixelIdxList{ii});
        xmin=min(xs);xmax=max(xs);
        ymin=min(ys);ymax=max(ys);
        if hori_vert==0
            lines=[lines;xmin,(ymax+ymin)/2,xmax,(ymax+ymin)/2;];
        else
            lines=[lines;(xmax+xmin)/2,ymin,(xmax+xmin)/2,ymax;];
        end
    end
end
lines=round(lines);
end