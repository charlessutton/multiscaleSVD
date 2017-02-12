function [ data ] = generate_triangle_kD(k, n, D, pulse_width, noise_sigma)
%This function generates a dataset compossed of n kD triangles, each genetated
%by adding k 1D triangles (sampled on D points in the range [0,1] and with 
%random mean)to each other.
%   k - the dimension of the pulses in the dataset
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigma - the half width of the triangle
%   noise_sigma - var of the noise (additive)

data = zeros(n,D);
for i=1:k
    data = data + generate_triangle_1D(n,D,pulse_width,noise_sigma);
end

