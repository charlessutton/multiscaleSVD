%function that returns the square matrices of norm2 distances between the
%points of a dataset 
% Values for all (i,j)
function [dm] = distance_matrix(dataset)
    y = pdist(dataset); %pairwise distance in a efficient format
    dm = squareform(y);
end