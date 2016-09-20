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
    '1-D gaussian pulse', ...
    '3 concatenated 1D gaussian pulse', ...
    '3 concatenated 1D gaussian pulse, noisy case', ...
    '5 concatenated 1D gaussian pulse', ...
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
algo_options = struct('it',15,'it_end',5);
switch example_id
    case 1
        data_options = struct('type','sphere','n',1000,'D',100,'k',9,'sigma_noise',0,'seed',555);
    case 2
        data_options = struct('type','sphere','n',1000,'D',100,'k',9,'sigma_noise',0.1,'seed',555);
    case 3
        data_options = struct('type','gaussian_pulse','n',500,'D',1000,'k',1,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 4
        data_options = struct('type','gaussian_pulse','n',500,'D',100,'k',3,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 5
        data_options = struct('type','gaussian_pulse','n',500,'D',100,'k',3,'sigma_noise',0.01,'sigma_pulse',0.1,'seed',555);
    case 6
        data_options = struct('type','gaussian_pulse','n',500,'D',100,'k',5,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);

end
noisy_data = generate_data(data_options);
%% automatic estimation

estimation =  automatic_estimation(noisy_data,algo_options);
fprintf('\n estimated dimension : %d', estimation);
fprintf('\n true dimension : %d \n ', data_options.k);
