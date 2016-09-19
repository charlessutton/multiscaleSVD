% function that give the minimum number of point to expect given a specific
% radius
function minimum  = min_nb_per_ball(distance_matrix,radius)
    bin_matrix = distance_matrix < radius ; % matrix that identify with points in the ball
    nb_point_per_ball = sum(bin_matrix,2) - 1; % vector ; number of points in each ball except from the center
    minimum = min(nb_point_per_ball);
end