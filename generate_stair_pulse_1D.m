function [ data ] = generate_stair_pulse_1D( n, D, pulse_width, noise_sigma )
%This function generates a dataset compossed of n 1D pulses, each sampled
%on D points in the range [0,1] and with random mean
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigme - the width of the pulse
%   noise_sigma - var of the noise

data = zeros(n,D);
I = linspace(0,1,D);
for i=1:n
    start_point = (1-pulse_width) * rand ;   %random mean values in the range [0,1] for the curve balls genetated
    start_point_idx = find(I > start_point,1);
    end_point_idx = find(I>start_point+pulse_width,1);
    data(i,:) = zeros(1,D);
    data(i,start_point_idx:end_point_idx) = 1;
end

if noise_sigma > 0
    data = data + noise_sigma*abs(randn(n, D));
end

end

