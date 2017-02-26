%% this script performs local linarity verification of datasets
% Ideally it finds what is the maximum radius asserting local linearity 
% for a given customized pulse
%% parameters
%clear all
clc
options = struct();
options.type = 'gaussian';
options.noise_level = 0;
options.k = 3;
options.neigh = 1000;
options.D = 200;
options.width = 0.05;
options.mu = rand(1,options.k);

%% computing ratios

epsilons = 0.0001 * exp(1).^(1:11); 

ratio = zeros(1,length(epsilons));
avg_distance = zeros(1,length(epsilons));

for i = 1:length(epsilons)
    options.epsilon = epsilons(i);
    data = generate_neighs(options);
    sv = svd(data);
    ratio(i) = sum(sv(1:options.k))/sum(sv);
    
    DM = squareform(pdist(data));
    avg_distance(i) = mean(DM(1,2:options.neigh+1));
end
%% elementary signal

figure;
I = linspace(0,1,options.D);
plot(I,data(1,:));
title('elementary signal');

%% graph of ratio vs radius

figure;
semilogx(epsilons,ratio);
%plot(radii,ratio); % very convex
title('radius vs ratio (semi-log scale)')

figure;
%semilogx(radii,avg_distance);
plot(epsilons,avg_distance); % very convex
title('radius vs avg distance(semi-log scale)')

%% r_max

threshold = 0.95 ;
max_index = find(ratio<threshold,1) - 1;
disp('radius max')
eps_lin_max = epsilons(max_index)

%% average distance to the original pulse
options.epsilon = eps_lin_max;
data = generate_neighs(options);
DM = squareform(pdist(data));

disp('radius in MSVD')  
average_distance = mean(DM(1,2:options.neigh+1))


