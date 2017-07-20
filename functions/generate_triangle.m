function [ data ] = generate_triangle(data_options)
% this function generates a dataset of triangle signals given the data_options 
% parameters :
%   n - size of the dataset
%   D - num of sample points in the range [-1,1]
%   k - num of triangle summed
%   width - the half width of a triangle
%   circular : 'on' means the interval is circular and so overlap
%   gain : 'on' means we add rayleigh gain

data = zeros(data_options.n,data_options.D);
I = linspace(-1,1,data_options.D);

if strcmpi(data_options.circular,'on')
    %case circular
    half_width = data_options.width; % disclaimer, in the triangle case, half width is not witdh/2
    half_width_sample = round( half_width * data_options.D)+1; % convert number of sample points
    I_extended = linspace(-1 - half_width , 1 + half_width , data_options.D + 2*half_width_sample);
    data_extended = zeros(data_options.n, data_options.D + 2*half_width_sample);
    for i = 1:data_options.k
        for j = 1:data_options.n
            if strcmpi(data_options.gain, 'on')
                gain = raylrnd(sqrt(2/pi));
            else 
                gain = 1;
            end
            middle_point = 2*rand - 1;
            middle_point_idx =  find(I_extended > middle_point,1); 
            start_point_idx = find(I_extended > middle_point - data_options.width,1);
            end_point_idx = find(I_extended > middle_point + data_options.width,1)-1;
            middle_point + data_options.width
            data_extended(j,start_point_idx:middle_point_idx) = data_extended(j,start_point_idx:middle_point_idx) + (gain/data_options.width^2)*(I_extended(start_point_idx:middle_point_idx) - I_extended(start_point_idx));

            data_extended(j,middle_point_idx+1:end_point_idx) = data_extended(j,middle_point_idx+1:end_point_idx) - (gain/data_options.width^2)*(I_extended(middle_point_idx+1:end_point_idx) - I_extended(end_point_idx));
        end
    end

    data = data_extended(:,half_width_sample+1:data_options.D + half_width_sample);
    data(:,1:half_width_sample) = data(:,1:half_width_sample) + data_extended(:,data_options.D + half_width_sample+1 : data_options.D + 2*half_width_sample);
    data(:, data_options.D - half_width_sample + 1 : data_options.D ) = data(:, data_options.D - half_width_sample + 1 : data_options.D ) + data_extended(:, 1 : half_width_sample );
else
    
    for i = 1:data_options.k
        for j = 1:data_options.n
            if strcmpi(data_options.gain, 'on')
                gain = raylrnd(sqrt(2/pi));
            else 
                gain = 1;
            end
            middle_point = 2 * rand - 1;
            middle_point_idx =  find(I > middle_point,1); 
            start_point_idx = find(I > middle_point - data_options.width,1);
            end_point_idx = find(I>middle_point + data_options.width,1)-1;
            data(j,start_point_idx:middle_point_idx) = data(j,start_point_idx:middle_point_idx) +  (gain/data_options.width^2)*(I(start_point_idx:middle_point_idx) - I(start_point_idx));
            data(j,middle_point_idx+1:end_point_idx) =  data(j,middle_point_idx+1:end_point_idx)  - (gain/data_options.width^2)*(I(middle_point_idx+1:end_point_idx) - I(end_point_idx));
        end
    end
    
end


end   