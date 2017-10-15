%badly coded from generate_stair.m
function [ data ] = generate_stair(data_options)
% this function generates a dataset of stair signals given the data_options 
% parameters :
%   n - size of the dataset
%   D - num of sample points in the range [-1,1]
%   mu - 
%   width - the half width of a stair
%   circular : 'on' means the interval is circular and so overlap
%   gain : 'on' means we add rayleigh gain

data = zeros(data_options.n,data_options.D);
I = linspace(-1,1,data_options.D);

if strcmpi(data_options.circular,'on')
    %case circular
    half_width = data_options.width / 2 ;
    half_width_sample = round( 0.5* half_width * data_options.D)+1; % convert number of sample points
    I_extended = linspace(-1 - half_width , 1 + half_width , data_options.D + 2*half_width_sample);
    data_extended = zeros(data_options.n, data_options.D + 2*half_width_sample);
    for start_point = data_options.mu
        for j = 1:data_options.n
            
            gain = raylrnd(sqrt(2/pi));

            start_point_idx = find(I_extended > start_point,1);
            end_point_idx = find(I_extended > start_point+data_options.width,1);
            
            data_extended(j,start_point_idx:end_point_idx) = data_extended(j,start_point_idx:end_point_idx) + gain / data_options.width;
            
        end
    end

    data = data_extended(:,half_width_sample+1:data_options.D + half_width_sample);
    data(:,1:half_width_sample) = data(:,1:half_width_sample) + data_extended(:,data_options.D + half_width_sample+1 : data_options.D + 2*half_width_sample);
    data(:, data_options.D - half_width_sample + 1 : data_options.D ) = data(:, data_options.D - half_width_sample + 1 : data_options.D ) + data_extended(:, 1 : half_width_sample );
else
    
    for start_point = data_options.mu
        for j = 1:data_options.n
            
            gain = raylrnd(sqrt(2/pi));
            
            start_point_idx = find(I > start_point,1);
            end_point_idx = find(I>start_point+data_options.width,1);

            data(j,start_point_idx:end_point_idx) = data(j,start_point_idx:end_point_idx) + gain / data_options.width;
        end
    end
    
end


end   