function [ data ] = generate_pulse_kD( k, n, D, pulse_sigma, noise_sigma )
%This function generates a dataset compossed of n kD pulses, each genetated
%by adding k 1D pulses (sampled on D points in the range [0,1] and with 
%random mean)to each other.
%   k - the dimention of the pulses in the dataset
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigme - the std parameter ginven to the normal pdf function
%   noise_sigma - var of the noise

data = zeros(n,D);
for i=1:k
    data = data + generate_pulse_1D(n,D,pulse_sigma,noise_sigma);
end

