function [ k ] = estimate_dim_decreasing_weight(Eeigenval, radius, algo_options)

% function that perform that estimates the intrinsic dimension from the
% curves
% inputs : Eeigneval matrix  ( SV * radius )
% ouputs : estimation 

    weights = 1./radius';
    var_tmp = round(algo_options.it/2);
    weights(var_tmp:length(weights)) = 0;
    weights = weights / sum(weights);
    % we try to detect the first SV that doesn't grow like others
    diff_matrix = diff(Eeigenval,1);
    weighted_diff_matrix = bsxfun(@times, diff_matrix, weights);
    somme =  sum(weighted_diff_matrix,2);
    normalized = abs(somme)/sum(abs(somme));
    [argvalue, argmax] = max(normalized);
    
    k = argmax;

    %figure;
    %plot(normalized)
    %title('estimate dim weighted')
    
    %figure;
    %plot(diff(normalized))
    %title('diff estim dim weighted')

    if isempty(k)
        disp('no peak detected')
    end
end