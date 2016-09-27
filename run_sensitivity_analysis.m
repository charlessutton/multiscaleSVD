%% Sensitivity analysis 
% This file runs sensitivity analysis about different paratmeters

clear all

%% Choose the type of data you are interested in

% list of parameters to test
data_type  = { 'Sphere (k = 5,9,12)', ...
    'Concatenated pulse (k = 1,3,5)'};

fprintf('\n\n Select example to run:\n');
for k = 1:length(data_type),
    fprintf('\n [%d] %s',k,data_type{k});
end;
fprintf('\n\n  ');

while true,
    if (~exist('data_type_id') || isempty(data_type_id) || data_type_id==0),
        try
            data_type_id = input('');
            data_type_id = str2num(data_type_id);
        catch
        end;
    end;
    if (data_type_id>=1) && (data_type_id<=length(data_type)),
        break;
    else
        fprintf('\n %d is not a valid Example. Please select a valid Example above.',parameters_id);
        data_type_id=0;
    end;
end;

%% Choose the parameter you want to test

% list of parameters to test
parameters   = { 'ambient noise (sigma)', ...
    'ambient dimension (D)', ...
    'dataset size (n)' };

fprintf('\n\n Select example to run:\n');
for k = 1:length(parameters),
    fprintf('\n [%d] %s',k,parameters{k});
end;
fprintf('\n\n  ');

while true,
    if (~exist('parameters_id') || isempty(parameters_id) || parameters_id==0),
        try
            parameters_id = input('');
            parameters_id = str2num(parameters_id);
        catch
        end;
    end;
    if (parameters_id>=1) && (parameters_id<=length(parameters)),
        break;
    else
        fprintf('\n %d is not a valid Example. Please select a valid Example above.',parameters_id);
        parameters_id=0;
    end;
end;

2%% Configuration given inputs 

algo_options = struct('it',15,'it_end',5);

sensitivity_options = struct('sigma',[0,0.01,0.05,0.1,0.2], ...
    'D',[50,100, 200, 500, 1000], ...
    'n',[50,100,200,500]);

plot_options = struct();

switch data_type_id
    case 1
        data_options = struct('n',500,'D',500,'sigma_pulse',0.1,'sigma_noise',0.01,'seed',555);
        data_options.type = 'sphere';
        data_options.ks = [5, 9, 12];

    case 2
        data_options = struct('n',500,'D',800,'sigma_pulse',0.1,'sigma_noise',0.01,'seed',555);
        data_options.type = 'gaussian_pulse';
        data_options.ks = [1, 3, 5];
end

%sigma , D, n
switch parameters_id
    case 1
        sigma = sensitivity_options.sigma;
        datasets = cell(length(data_options.ks),length(sigma));
        for i = 1:length(data_options.ks)
            data_options.k = data_options.ks(i);
            for j = 1:length(sigma)
                data_options.sigma_noise = sigma(j);
                datasets{i,j} = generate_data(data_options);
            end
        end
        
        plot_options.xlabel = 'noise';
        plot_options.x = sigma;

    case 2
        D = sensitivity_options.D;
        datasets = cell(length(data_options.ks),length(D));
        for i = 1:length(data_options.ks)
            data_options.k = data_options.ks(i);
            for j = 1:length(D)
                data_options.D = D(j);
                datasets{i,j} = generate_data(data_options);    
            end
        end
        plot_options.xlabel = 'ambient dimension';
        plot_options.x = D;
        
    case 3

        n = sensitivity_options.n;
        datasets = cell(length(data_options.ks),length(n));
        for i = 1:length(data_options.ks)
            data_options.k = data_options.ks(i);
            for j = 1:length(n)
                data_options.n = n(j);
                datasets{i,j} = generate_data(data_options);        
            end
        end
        plot_options.xlabel = 'sample size';
        plot_options.x = n;
end 

%% datasets
disp('Performing estimations')
disp('Take some time ...')
estimations = zeros(size(datasets));
for i = 1:size(datasets,1)
    for j = 1:size(datasets,2)
        i
        j
        aut_est = automatic_estimation(datasets{i,j}, algo_options)
        if ~isempty(aut_est)
            estimations(i,j) = aut_est;
        end
    end
end
disp('done')
%% logplot

formatSpec = 'Sensitivity analysis of %s wrt the %s';
plot_options.title = sprintf(formatSpec, data_type{data_type_id}, plot_options.xlabel);

figure;
for i=1:size(datasets,1)
    %semilogx(plot_options.x,estimations);
    plot(plot_options.x,estimations(i,:))
    hold on
end
set(gca,'XTick',plot_options.x)
set(gca,'YTick',data_options.ks(1) - 3: data_options.ks(length(data_options.ks)) + 3)
ylim([data_options.ks(1) - 3 data_options.ks(length(data_options.ks)) + 3])
title(plot_options.title);
xlabel(plot_options.xlabel) % x-axis label
ylabel('estimation') % y-axis label


