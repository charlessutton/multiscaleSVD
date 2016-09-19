function [ data ] = generate_pulse_1D( n, D, pulse_sigma, noise_sigma )
%This function generates a dataset compossed of n 1D pulses, each sampled
%on D points in the range [0,1] and with random mean
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigme - the std parameter ginven to the normal pdf function
%   noise_sigma - var of the noise

x = linspace(0,1,D);
data = zeros(n,D);
mu = rand(n,1);    %random mean values in the range [0,1] for the curve balls genetated
for i=1:n
    data(i,:) = normpdf(x, mu(i), pulse_sigma);
end

if noise_sigma > 0
    data = data + noise_sigma*abs(randn(n, D));
end

end

