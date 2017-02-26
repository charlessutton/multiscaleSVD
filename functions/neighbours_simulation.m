%% parameters
clear all
clc
options = struct();
options.type = 'gaussian';
options.noise_level = 0;
options.k = 5;
options.neigh = 1000;
options.D = 200;
options.width = 0.05;
options.radius = 0.01;

%% simulate data
data = generate_neighs(options);

%% display neighbours
nb_to_display = 4;
I = linspace(0,1,options.D);
figure;
plot(I, data(1,:));
legend('original signal');
hold on
p = randperm(options.neigh, nb_to_display);
for i = p
    plot(I, data(1+i,:));
    hold on
end

%% SVD
sv = svd(data);
ratio = sum(sv(1:options.k)) / sum(sv)
