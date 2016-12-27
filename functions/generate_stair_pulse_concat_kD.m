function [ data ] = generate_stair_pulse_concat_kD( k, n, D, pulse_width, noise_sigma)
% concatenation of k stair pulses
%   k - number of concatenated pulses
%   n - number of pulses to generate
%   D - num of sample points in the range [0,1]
%   pulse_width - the var of the pulse
%   noise_sigma - var of the noise

data = zeros(n,D);
I = linspace(0,1,D);
interval_idx = linspace(0,1,k+1);

for j = 1:n
    for i = 1:k 
        left_idx = interval_idx(i) ;
        right_idx = interval_idx(i+1) - pulse_width ;
        starting_point = left_idx + (right_idx - left_idx )*rand;    
        data(j,:) = data(j,:) + stair_pulse(I, starting_point, pulse_width);
    end
end 

if noise_sigma > 0
    data = data + noise_sigma*abs(randn(n, D));
end

end
