function [ k ] = estimate_dim(Eeigenval)

% function that perform that estimates the intrinsic dimension from the
% curves
% inputs : Eeigneval matrix  ( SV * radius )
% ouputs : estimation 

    % we try to detect the first SV that doesn't grow like others
    diff_matrix = diff(Eeigenval,1);
    somme =  sum(diff_matrix,2);
    normalized = abs(somme)/sum(abs(somme)) ;
    
    % we detect the first "gap peak" by tresholding
    % it estimates the intrinsic dimension 
    k = find(normalized > 0.1, 1);
    
end