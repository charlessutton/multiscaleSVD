%% Parameters data
clear all
data_options = struct();
data_options.type = 'triangle';
data_options.noise_level = 0;
data_options.k = 20;
data_options.n = 3;
data_options.D = 1000;
data_options.gain = 'off';
data_options.circular = 'off';
data_options.width = 0.1;

data = generate_data(data_options);

for i = 1:data_options.n
    figure;
    plot(data(i,:))
end