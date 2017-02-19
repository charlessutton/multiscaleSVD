%% Parameters data
clear all
data_options = struct();
data_options.type = 'triangle';
data_options.noise_level = 0.1;
data_options.k = 4;
data_options.n = 1000;
data_options.D = 100;
data_options.gain = 'off';
data_options.circular = 'on';
data_options.width = 0.1;
%% Generate data
data = generate_data(data_options);
%% MUSIC built in
pmusic(data, data_options.k);
%% getting singular values

sv = svd(data);
M = length(sv);
likelihood = zeros(1,M);
AIC = zeros(1,M);
MDL = zeros(1,M);

for p = fliplr(1:M)
    likelihood(p) = LR(sv,p,data_options.n);
    AIC(p) = log(likelihood(p)) + 0.5*(M-p)*(M+p+1);
    MDL(p) = log(likelihood(p)) +  0.25*(M-p)*(M+p+1)*log(data_options.n);
end

figure;
plot(likelihood(1:10))
title('LR')
figure;
plot(AIC(1:10))
title('AIC')
figure;
plot(MDL(1:10))
title('MDL')