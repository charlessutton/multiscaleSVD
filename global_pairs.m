% This is my main script to perform experiments : selecting the type of pulses and get MSVD plots 
%% Parameters data
clear all
clc
tic
data_options = struct();
data_options.type = 'gaussian';
data_options.noise_level = 0;
data_options.k = 2;
data_options.n = 20000;
data_options.D = 200;
data_options.gain = 'off';
data_options.circular = 'on';
data_options.width = 0.05;

data_options.neigh = 1000;
data_options.mu = rand(1,data_options.k);

%% Generating dataset of pulses 
noisy_data = generate_data(data_options);

%% PCA reduction
[U,S,V] = svd(noisy_data);
SV = diag(S);

%% visualization
clear legendInfo;
idx = 2;
I = linspace(0,1,data_options.D);
figure;
plot(I, noisy_data(idx,:));
hold on;
legendInfo{1} = ['signal' ];
compteur = 1;
for k = 8:11
    compteur = compteur + 1;
    clear S_k
    numberOfDimensions = k;
    S_k = zeros(data_options.n,data_options.D);
    S_k(1:data_options.D,1:data_options.D) = diag([SV(1:k)',zeros(1,length(SV)-k)]);
    reduced_data = U * S_k *V';
    plot(I, reduced_data(idx,:))
    legendInfo{compteur} = ['k = ' num2str(k)]; 
    hold on
end
legend(legendInfo,'location','northeastoutside');
