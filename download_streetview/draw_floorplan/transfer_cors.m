function [ camera_xs,camera_ys ] = transfer_cors( location_data )
meter2pixel=4;
camera_xs=300+location_data.allm*meter2pixel;
camera_ys=300+location_data.alln*meter2pixel;
end