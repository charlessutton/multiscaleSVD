% this script illustrates the distribution of the "best" radius over a
% specific manifold
clear all
clc

tic

data_options = struct();
data_options.type = 'gaussian';
data_options.k = 2;
data_options.D = 200;
data_options.gain = 'off';
data_options.circular = 'on';
data_options.width = 0.05;
data_options.neigh = 100;
data_options.mu = rand(1,data_options.k);
epsilons = 0.0001 * exp(1).^(1:12);
I = linspace(0,1,data_options.D);

% recommended set of radii

%k2
%epsilons = 0:0.05:0.5

%k3
epsilons = 0:0.05:0.4;

%k4
%epsilons = 0:0.05:0.6;

n_bis = 1000;

dataviz = zeros(n_bis,data_options.D);
idxviz =  zeros(n_bis,1);
for k=1:n_bis
    ratio = zeros(1,length(epsilons));
    %avg_distance = zeros(1,length(epsilons));
    data_options.mu = rand(1,data_options.k);

    for i = 1:length(epsilons)
        data_options.epsilon = epsilons(i);
        data = generate_neighs(data_options);
        sv = svd(data);
        ratio(i) = sum(sv(1:data_options.k))/sum(sv);
        %DM = squareform(pdist(data));
        %avg_distance(i) = mean(DM(1,2:data_options.neigh+1));
    end

    threshold = 0.80 ;
    lin_index = find(ratio<threshold,1) - 1;
     
    if ~isempty(lin_index) 
        eps_lin_max(k) = epsilons(lin_index);
        for ii = 1:data_options.k
            dataviz(k,:) = dataviz(k,:) + normpdf(I, data_options.mu(ii), data_options.width);
        end
        idxviz(k) = lin_index;
    end
end    
toc

figure;
h = histogram(eps_lin_max,round(sqrt(n_bis)));
100* h.Values / sum(h.Values)
%% Visualization

selected_data = dataviz(eps_lin_max == epsilons(2),:);

for idx=1:5%= randsample(size(selected_data,1),5)
    figure;
    plot(I,selected_data(idx,:));   
end


[COEFF,SCORE] = princomp(data);



