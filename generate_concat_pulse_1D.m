function [ data ] = generate_concat_pulse_1D(k, n, D, pulse_sigma, noise_sigma )
%   k - number of concatenated pulses
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_sigma - the var of the pulse
%   noise_sigma - var of the noise

data = zeros(n,D);
I = linspace(0,k,D);
interval_idx = linspace(0,k,k+1);
gap = 2*pulse_sigma ;

for j = 1:n
    for i = 1:k 
        left_idx = interval_idx(i) + gap ;
        right_idx = interval_idx(i+1) - gap ;
        mu = left_idx + (right_idx - left_idx )*rand;    
        data(j,:) = data(j,:) + normpdf(I, mu, pulse_sigma);
    end
end 

if noise_sigma > 0
    data = data + noise_sigma*abs(randn(n, D));
end
end
