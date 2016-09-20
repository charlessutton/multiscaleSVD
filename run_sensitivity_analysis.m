%% Sensitivity analysis 
% This file runs sensitivity analysis about different paratmeters

clear all

%% Choose the type of data you are interested in

% list of parameters to test
data_type  = { 'Sphere (k = 5)', ...
    'Sphere (k = 9)', ...
    'gaussian pulse (k = 1)', ...
    'gaussian pulse (k = 3)',...
    'gaussian pulse (k = 5)'};

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

%% Configuration given inputs 

algo_options = struct('it',15,'it_end',5);
data_options = struct('n',1000,'D',100,'sigma_pulse',0.1,'sigma_noise',0.01,'seed',555);

sensitivity_options = struct('sigma',[0,0.01,0.05,0.1,0.2], ...
    'D',[50,100,200], ...
    'n',[200,500,1000]);

plot_options = struct();

switch data_type_id
    case 1
        data_options.type = 'sphere';
        data_options.k = 5;

    case 2
        data_options.type = 'sphere';
        data_options.k = 9;
        
    case 3
        data_options.type = 'gaussian_pulse';
        data_options.k = 1;

    case 4
        data_options.type = 'gaussian_pulse';
        data_options.k = 3;
    case 5
        data_options.type = 'gaussian_pulse';
        data_options.k = 3;
end

%sigma , D, n
switch parameters_id
    case 1
        sigma = sensitivity_options.sigma;
        datasets = cell(length(sigma),1);
        for i = 1:length(sigma)
            data_options.sigma = sigma(i);
            datasets{i} = generate_data(data_options);
        end
        
        plot_options.xlabel = 'noise';
        plot_options.x = sigma;

    case 2
        D = sensitivity_options.D;
        datasets = cell(length(D),1);
        for i = 1:length(D)
            data_options.D = D(i);
            datasets{i} = generate_data(data_options);    
        end
        plot_options.xlabel = 'ambiant dimension';
        plot_options.x = D;
        
    case 3

        n = sensitivity_options.n;
        datasets = cell(length(n),1);
        for i = 1:length(n)
            data_options.n = n(i);
            datasets{i} = generate_data(data_options);        
        end
        
        plot_options.xlabel = 'sample size';
        plot_options.x = n;
end 

%% datasets
disp('Performing estimations')
disp('Take some time ...')
estimations = zeros(length(datasets),1);
for i = 1:length(estimations)
    estimations(i) = automatic_estimation(datasets{i}, algo_options);
end
disp('done')
%% logplot

formatSpec = 'Sensitivity analysis of %s wrt the %s';
plot_options.title = sprintf(formatSpec, data_type{data_type_id}, plot_options.xlabel);

figure;
%semilogx(plot_options.x,estimations);
plot(plot_options.x,estimations);
title(plot_options.title);
xlabel(plot_options.xlabel) % x-axis label
ylabel('estimation') % y-axis label
