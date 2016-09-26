function [ all_building_deformations ] = enumerate_solution_relative_init( xrange,yrange,CH_centers,FH_centers,DH_centers,WB_centers,WT_centers,gtCH,gtFH,gtDH,gtWB,gtWT,gtXY )
xshifts=-xrange:xrange;
yshifts=-yrange:yrange;

xshifts=xshifts-gtXY(1);
yshifts=yshifts-gtXY(2);

all_building_deformations=combvec(xshifts,yshifts,CH_centers-gtCH,FH_centers-gtFH,DH_centers-gtDH,WB_centers-gtWB,WT_centers-gtWT);
all_building_deformations=all_building_deformations';
end