% automatic estimation from SV
% We compute the area between SV at the best scale and estimate k according to the highest
% gap
% INPUT :Eeigenval : the "SV curves" or "Relative SV curves" at radius best scale +/- spread
% OUPUT : The area between consecutive curves
function [ diff_areas ] = area_best_scale(radii, Eeigenval)
    
    nb_row =  size(Eeigenval,1);
    areas = zeros(1,nb_row);
    for i = 1:nb_row 
        areas(i) = trapz(radii, Eeigenval(i,:));
    end

    diff_areas = -1 * diff(areas,1); % area between consecutive curves
end