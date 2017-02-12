% T-SNE vizualisation of a pulse data set

for perplexity = [5,10,15,30,50]
    data_options = struct('type','gaussian_pulse_sum','n',500,'D',30,'k',1,'sigma_pulse',0.1,'sigma_noise',0,'seed',555);

    X = generate_data(data_options);
    labels = data_options.k * ones(data_options.n,1);

    for k = 2:4
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