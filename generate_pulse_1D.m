function [ norm ] = generate_pulse_1D( n, mu, n_sigma )
%This function generates a 1D bell curve
%   n - number of sampels
%   mu - mean
%   n_sigma - var of the noise %use 0.1

sigma = sqrt(0.02);
x = linspace(0,1,n);
norm = normpdf(x, mu, sigma);
%norm = uniform_quantizer(norm, n);
if sigma > 0
    norm = norm + n_sigma*randn(1, length(x));
end
%plot(x, norm);
end

