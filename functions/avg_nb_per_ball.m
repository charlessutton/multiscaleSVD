%function that given a radius and a matrix of distances between points of
%the data set returns the average number of point in balls of radius r
function [avg,dev] = avg_nb_per_ball(distance_matrix,radius)
    bin_matrix = distance_matrix < radius ; % matrix that identify with points in the ball
    nb_point_per_ball = sum(bin_matrix,2) - 1; % vector ; number of points in each ball except from the center
    avg = mean(nb_point_per_ball);
    dev = std(nb_point_per_ball);
end