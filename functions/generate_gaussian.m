function [ data ] = generate_gaussian(data_options)
% this function generates a dataset of gaussian signals given the data_options 
% parameters :
%   n - size of the dataset
%   D - num of sample points in the range [-1,1]
%   k - num of signals summed
%   width - the std parameter given to the normalpdf function
%   circular : 'on' means the interval is circular and so overlap
%   gain : add rayleigh gain

data = zeros(data_options.n,data_options.D);
I = linspace(-1,1,data_options.D);

if strcmpi(data_options.circular,'on')
    %case circular
    half_width = norminv(0.99,0,data_options.width); % disclaimer, in the gaussian case, half width is not witdh/2
    half_width_sample = round(half_width * data_options.D);
    I_extended = linspace(-1 - half_width , 1 + half_width , data_options.D + 2*half_width_sample);
    data_extended = zeros(data_options.n, data_options.D + 2*half_width_sample);
    for i = 1:data_options.k
        mu = 2*rand(data_options.n,1) - 1;    %random mean values in the range [0,1] for the curve balls genetated
        for j = 1:data_options.n
            if strcmpi(data_options.gain, 'on')
                gain = raylrnd(sqrt(2/pi));
            else 
                gain = 1;
            end
            data_extended(j,:) = data_extended(j,:) + gain * normpdf(I_extended, mu(j), data_options.width);
        end
    end

    data = data_extended(:,half_width_sample+1:data_options.D + half_width_sample);
    data(:,1:half_width_sample) = data(:,1:half_width_sample) + data_extended(:,data_options.D + half_width_sample+1 : data_options.D + 2*half_width_sample);
    data(:, data_options.D - half_width_sample + 1 : data_options.D ) = data(:, data_options.D - half_width_sample + 1 : data_options.D ) + data_extended(:, 1 : half_width_sample );
    
else
    
    for i = 1:data_options.k
        mu = 2*rand(data_options.n,1)-1;    %random mean values in the range [0,1] for the curve balls genetated
        for j = 1:data_options.n
            if strcmpi(data_options.gain, 'on')
                gain = raylrnd(sqrt(2/pi));
            else 
                gain = 1;
            end
            data(j,:) = data(j,:) + gain * normpdf(I, mu(j), data_options.width);
        end
    end
    
end

end   