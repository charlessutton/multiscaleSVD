%% Choose example
clear all
% This file runs all examples of the presentation / report and creates corresponding figures 
% Execute 'clear all' before running the script, otherwise it will re-run with any existing options without prompting the user.

%TO DO :
% add timing information
% add examples

% list of examples
examples   = { '9-d sphere without noise', ...
    '9-d sphere with little noise', ...
    '1-D gaussian pulse without noise', ...
    '1-D gaussian pulse with noise', ...
    '3 concatenated 1D gaussian pulse', ...
    '3 concatenated 1D gaussian pulse, noisy case', ...
    '5 concatenated 1D gaussian pulse', ...
    '5 concatenated 1D gaussian pulse, noisy case', ...
    '5 summed 1D gaussian thin pulse', ...
    '5 summed 1D gaussian thick pulse', ...
    '1D stair pulse', ...
    '5 summed 1D stair pulses', ...
    '5 concatenated 1D stair pulses'
    };

fprintf('\n\n Select example to run:\n');
for k = 1:length(examples),
    fprintf('\n [%d] %s',k,examples{k});
end;
fprintf('\n\n  ');

while true,
    if (~exist('example_id') || isempty(example_id) || example_id==0),
        try
            example_id = input('');
            example_id = str2num(example_id);
        catch
        end;
    end;
    if (example_id>=1) && (example_id<=length(examples)),
        break;
    else
        fprintf('\n %d is not a valid Example. Please select a valid Example above.',example_id);
        example_id=0;
    end;
end;

%% Generate data of the chosen example
algo_options = struct('it',15,'it_end',5,'subsample',false,'sqrt_subsampling',15);
switch example_id
    case 1
        data_options = struct('type','sphere','n',1000,'D',100,'k',9,'sigma_noise',0,'seed',555);
    case 2
        data_options = struct('type','sphere','n',1000,'D',100,'k',9,'sigma_noise',0.1,'seed',555);
    case 3
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',1,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 4
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',1,'sigma_noise',0.1,'sigma_pulse',0.1,'seed',555);
    case 5
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',3,'sigma_noise',0,'sigma_pulse',0.2,'seed',555);
    case 6
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',3,'sigma_noise',0.01,'sigma_pulse',0.1,'seed',555);
    case 7
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 8
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',5,'sigma_noise',0.01,'sigma_pulse',0.05,'seed',555);
    case 9
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.01,'seed',555);
    case 10
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.02,'seed',555);
    case 11
        data_options = struct('type','stair_sum','n',1000,'D',1000,'k',1,'sigma_noise',0,'sigma_pulse',0.5,'seed',555);
    case 12
        data_options = struct('type','stair_sum','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 13
        data_options = struct('type','stair_concat','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.05,'seed',555);
end
noisy_data = generate_data(data_options);
%% SVD cumsum

SV = svd(noisy_data);
cumulative_SV = cumsum(SV','reverse');

%% Plotting
figure;
plot(linspace(0,1,1000) ,noisy_data(2,:));
ylim([0 50])
title('sum of 5 pulses')

figure;
plot(1:size(SV,1),SV);
xlim([0,90])
%title('SV')

figure;
plot(1:size(SV,1),cumulative_SV);
xlim([0,70])
title('cumulative SV')


