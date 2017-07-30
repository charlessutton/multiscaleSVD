%function that given data options and a threshold, gives the best scale
%using binary search on the variance of the parameter neighborhood
%then we deduce the average ratio
function [radius, spread, epsilon] = best_scale(data_options, threshold)

% initialization
eps_min = 0; %var min on the parameters

switch data_options.type
    case 'stair'
    eps_max = 8;
    otherwise 
    eps_max = 2; % var max on the parameters
end
threshFlag = true;
counter = 0;
tolerance = 0.01; %tolerance 1%
seed = randi(10000); % random selected seed to ensure comparison over different epsilons
% binary search
while threshFlag  && counter < 20
    counter = counter + 1;
    
    data_options.epsilon = ( eps_min + eps_max ) / 2;
    
    %voir_eps = ( eps_min + eps_max ) / 2
    pratio = zeros(1,data_options.tries); % point ratio
    rng(seed); 
    for i = 1:data_options.tries        
        data_options.mu = rand(1,data_options.k); %selecting a random point on the manifold
        data = generate_neighs(data_options);
        sv = svd(data);
        pratio(i) = sum(sv(1:data_options.k))/sum(sv); 
    end
    
    ratio = mean(pratio);
    
    if abs(ratio-threshold)<tolerance
        threshFlag = false;        
    elseif ratio < threshold - tolerance
        eps_max = data_options.epsilon;        
    elseif ratio > threshold + tolerance
        eps_min = data_options.epsilon;
    end
    
end

% once the best epsilon is found, we compute average radius and average
% spread

pradius = zeros(1,data_options.tries);

rng(seed); 
for i = 1:data_options.tries
    data_options.mu = rand(1,data_options.k); %selecting a random point on the manifold
    data = generate_neighs(data_options);
    DM = squareform(pdist(data));
    pradius(i) = quantile(DM(1,2:data_options.neigh+1),0.95);

%     if i < 5
%         figure;
%         hist(DM(1,2:data_options.neigh+1))
%     end
end
ratio = mean(pratio);
epsilon = data_options.epsilon;
radius = mean(pradius); %since the noise is gaussian
spread = std(pradius);
end