% useful script to see what a neighboor looks like

%% parameters
clear all
clc
options = struct();
options.type = 'gaussian';
options.noise_level = 0;
options.k = 3;
options.neigh = 10;
options.D = 200;
options.width = 0.05;
options.epsilon = 0.1;

%% simulate data
data = generate_neighs(options);

%% display neighbours

nb_to_display = 1;
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
