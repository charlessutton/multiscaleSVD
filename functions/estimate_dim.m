function [ k ] = estimate_dim(Eeigenval)

% function that perform that estimates the intrinsic dimension from the
% curves
% inputs : Eeigneval matrix  ( SV * radius )
% ouputs : estimation 

    %we compute gaps 
    diff_matrix = diff(Eeigenval,1);
    avg =  mean(abs(diff_matrix),2);
    
    % we detect the first "gap peak" indicating the intrinsic dimension
    % estimation
    diff_diff = diff(avg);
    k = find(diff_diff < 0, 1);
    
end