% T-SNE vizualisation of a pulse data set
%% Parameters data
clear all
data_options = struct();
data_options.type = 'gaussian';
data_options.noise_level = 0.1;
data_options.k = 1;
data_options.n = 1000;
data_options.D = 30;
data_options.gain = 'off';
data_options.circular = 'on';
data_options.width = 0.01;
%% 

for perplexity = [10,30]
    
    X = generate_data(data_options);
    labels = ones(data_options.n,1);

    for k = 2:10
        data_options.k = k;
        X = [X; generate_data(data_options)];
        labels = [labels ; data_options.k * ones(data_options.n,1)];
    end
    % Set parameters
    no_dims = 2;
    initial_dims = data_options.D;

    % Run t?SNE
    mappedX = tsne(X, [], no_dims, initial_dims, perplexity);
    % Plot results
    figure;
    gscatter(mappedX(:,1), mappedX(:,2), labels);
    title( sprintf('\n perplexity = %d', perplexity))
end