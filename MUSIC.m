%% Parameters data
clear all
data_options = struct();
data_options.type = 'gaussian';
data_options.noise_level = 0.4;
data_options.k = 3;
data_options.n = 50;
data_options.D = 50;
data_options.gain = 'off';
data_options.circular = 'off';
data_options.width = 0.05;
%% Generate data
data = generate_data(data_options);
figure;
plot(data(1,:));
title('signal sample');
%% MUSIC built in
% pmusic(data, data_options.k);
%% getting singular values

sv = svd(data);
p = length(sv);

%likelihood = zeros(1,p);
lr_wax = zeros(1,p);
AIC = zeros(1,p);
MDL = zeros(1,p);

for k = 0:p-1
    %likelihood(k) = LR(sv,k,data_options.n);
    lr_wax(k+1) = LR_wax(sv,k,data_options.n);
    AIC(k+1) = -2*log(lr_wax(k+1)) + 2*k*(2*p-k);
    MDL(k+1) = -2*log(lr_wax(k+1)) +  0.5*k*(2*p-k)*log(data_options.n);
end

figure; plot(0:p-1,lr_wax); title('LR WAX');
figure;plot(0:p-1,AIC);title('AIC');
figure;plot(0:p-1,MDL);title('MDL');
figure; scatter(1:length(sv),sv,'filled'); title('SV');

[~,AIC_argmin] = min(AIC);
disp(AIC_argmin-1)
[~,MDL_argmin] = min(MDL);
disp(MDL_argmin-1)