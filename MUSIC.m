%% Parameters data
clear all
data_options = struct();
data_options.type = 'gaussian';
data_options.noise_level = 0;
data_options.k = 2;
data_options.n = 10000;
data_options.D = 200;
data_options.gain = 'off';
data_options.circular = 'off';
data_options.width = 0.05;
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

for p = 1:M
    likelihood(p) = LR(sv,p,data_options.n);
    AIC(p) = log(likelihood(p)) + 0.5*(M-p)*(M+p+1);
    MDL(p) = log(likelihood(p)) +  0.25*(M-p)*(M+p+1)*log(data_options.n);
end

figure;
plot(likelihood)
title('LR')
figure;
plot(AIC)
title('AIC')
figure;
plot(MDL)
title('MDL')