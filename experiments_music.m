%% Parameters data
clear all
close all
clc
tic
%diary('/Users/Code/Desktop/hello_diary')
%diary on
data_options = struct();
data_options.type = 'gaussian';
data_options.noise_level = 0.1;
data_options.mu = [-0.5, 0, 0.9];
data_options.n = 5000;
data_options.D = 200;
data_options.gain = 'on';
data_options.circular = 'on';
data_options.width = 0.1;

data_options.neigh = 1000;
data_options.tries = 50;
%% Parameters algo
radius_options = struct('it',5,'it_end',2,'it_start',5,'it_mid',4);

%% Subsampling options 
sub_options = struct('state',true,'nb',round(sqrt(data_options.n)));

%% Plotting options
plt_options = struct('sample',true,'avg',true,'msvd',true,'rmsvd',true);

%% Generating dataset of pulses 
noisy_data = generate_music_data(data_options);
%% plot
I = linspace(-1,1,data_options.D);
close all
for i=50:55
plot(I,noisy_data(i,:))
hold on
end

%% MUSIC

pmusic(noisy_data, length(data_options.mu))

