function [ all_building_deformations ] = enumerate_solution_relative( xrange,yrange,CH_centers,FH_centers,DH_centers,WB_centers,WT_centers,gtCH,gtFH,gtDH,gtWB,gtWT )
xshifts=-xrange:xrange;
yshifts=-yrange:yrange;
all_building_deformations=combvec(xshifts,yshifts,CH_centers-gtCH,FH_centers-gtFH,DH_centers-gtDH,WB_centers-gtWB,WT_centers-gtWT);
all_building_deformations=all_building_deformations';
end