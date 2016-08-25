function [ data ] = generate_concat_pulse_1D( n, D, pulse_sigma, noise_sigma )
%This function generates a dataset compossed of n 1D pulses, each sampled
%on D points in the range [0,1] and with random mean
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigme - the width of the pulse
%   noise_sigma - var of the noise

data = zeros(n,2*D);
I1 = linspace(0,0.5,D);
I2 = linspace(0.5,1,D);

for i=1:n
    %random mean values in the range [0,1] for the curve balls genetated
    mu1 = 0.5*rand;
    mu2 = 0.5*rand + 0.5;
    data(i,1:D) = normpdf(I1, mu1, pulse_sigma);
    data(i,D+1:2*D) = normpdf(I2, mu2, pulse_sigma);

end

if noise_sigma > 0
    data = data + noise_sigma*abs(randn(n, 2*D));
end
end
