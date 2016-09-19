%function that returns 
% sd_m the sorted distance matrix
% nn_m the index of each neighbor sorted by distance
% it appears that function sort use the quicksort algo (see. http://ch.mathworks.com/matlabcentral/answers/96656-what-type-of-sort-does-the-sort-function-in-matlab-perform)

function [sd_m, nn_m] = NN_matrices(distance_matrix)
    sd_m = zeros(size(distance_matrix)); %sorted distance
    nn_m = zeros(size(distance_matrix)); % nearest neighbors (index)
    for i=1:size(distance_matrix,1)
        [sd,nn] = sort(distance_matrix(i,:));
        sd_m(i,:) = sd;
        nn_m(i,:) = nn;
    end
end