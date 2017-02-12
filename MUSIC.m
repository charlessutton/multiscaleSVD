%% %% Choose example
clear all
% This file runs all examples of the presentation / report and creates corresponding figures 
% Execute 'clear all' before running the script, otherwise it will re-run with any existing options without prompting the user.

%TO DO :
% add timing information
% add examples
noise_level = 0;
% list of examples
examples   = { '1D gaussian wide pulse', ...
    '2 summed 1D gaussian wide pulse', ...
    '3 summed 1D gaussian wide pulse', ...
    '4 summed 1D gaussian wide pulse', ...
    '1D stair wide pulse', ...
    '2 summed 1D stair wide pulses',...
    '3 summed 1D stair wide pulses', ...
    '4 summed 1D stair wide pulses',...
    '1D wide triangle', ...
    '2 summed 1D triangles', ...
    '3 summed 1D triangles', ...
    '4 summed 1D triangles', ...
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

1%% Generate data of the chosen example
algo_options = struct('it',15,'it_end',5,'subsample',true,'sqrt_subsampling',10);

switch example_id

    case 1
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',300,'k',1,'sigma_pulse',0.1,'seed',555);
    case 2
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',300,'k',2,'sigma_pulse',0.1,'seed',555);
    case 3
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',300,'k',3,'sigma_pulse',0.1,'seed',555);
    case 4
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',300,'k',4,'sigma_pulse',0.1,'seed',555);
    case 5
        data_options = struct('type','stair_sum','n',1000,'D',300,'k',1,'sigma_pulse',0.2,'seed',555);
    case 6
        data_options = struct('type','stair_sum','n',1000,'D',300,'k',2,'sigma_pulse',0.2,'seed',555);
    case 7
        data_options = struct('type','stair_sum','n',1000,'D',300,'k',3,'sigma_pulse',0.2,'seed',555);
    case 8
        data_options = struct('type','stair_sum','n',1000,'D',300,'k',4,'sigma_pulse',0.2,'seed',555);               
    case 9
        data_options = struct('type','triangle_sum','n',1000,'D',300,'k',1,'sigma_pulse',0.1,'seed',555);               
    case 10
        data_options = struct('type','triangle_sum','n',1000,'D',300,'k',2,'sigma_pulse',0.1,'seed',555);               
    case 11
        data_options = struct('type','triangle_sum','n',1000,'D',300,'k',3,'sigma_pulse',0.1,'seed',555);               
    case 12
        data_options = struct('type','triangle_sum','n',1000,'D',300,'k',4,'sigma_pulse',0.1,'seed',555);               

end
data_options.sigma_noise = noise_level;
noisy_data = generate_data(data_options);
%% MUSIC

