function [ data ] = generate_triangle_1D( n, D, pulse_sigma, noise_sigma )
%This function generates a dataset compossed of n 1D triangles, each sampled
%on D points in the range [0,1] and with random mean
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigma - the half width of the triangle
%   noise_sigma - var of the noise

data = zeros(n,D);
I = linspace(0,1,D);
for i=1:n
    middle_point = pulse_sigma + (1 - 2*pulse_sigma) * rand;
    middle_point_idx =  find(I > middle_point,1); 
    start_point_idx = find(I > middle_point - pulse_sigma,1);
    end_point_idx = find(I>middle_point + pulse_sigma,1)-1;
    data(i,:) = zeros(1,D);
    data(i,start_point_idx:middle_point_idx) = (1/pulse_sigma^2)*(I(start_point_idx:middle_point_idx)) - (middle_point-pulse_sigma)/pulse_sigma^2;
    data(i,middle_point_idx:end_point_idx) = -(1/pulse_sigma^2)*(I(middle_point_idx:end_point_idx)) + (middle_point+pulse_sigma)/pulse_sigma^2;
end

if noise_sigma > 0
    data = data + noise_sigma*abs(randn(n, D));
end

end
