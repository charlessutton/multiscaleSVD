
% this function wraps all data generating functions for the project
% badly coded from generate_data
function [data] = generate_music_data(data_options)

% set default values for empty fields
% elementary signal
if ~isfield(data_options,'type') data_options.type = 'gaussian'; end
if ~isfield(data_options,'width') data_options.width = 0.1; end
if ~isfield(data_options,'noise_level') data_options.width = 0.1; end

%dataset
if ~isfield(data_options,'n') data_options.n = 1000; end
if ~isfield(data_options,'D') data_options.D = 50; end
%if ~isfield(data_options,'k') data_options.k = 2; end
if ~isfield(data_options,'mu') data_options.mu = [0.25, 0.75]; end
if ~isfield(data_options,'circular') data_options.circular = 'on'; end

data_options.gain = 'on';

if ~isfield(data_options,'seed') data_options.seed = 555; end

switch data_options.type
    case 'gaussian'
        data = generate_music_gaussian(data_options);
    case 'triangle'
        data = generate_music_triangle(data_options);
    case 'stair'
        data = generate_music_stair(data_options);

end        
% adding gaussian noise on data
if data_options.noise_level > 0
    data = data + data_options.noise_level * randn(data_options.n, data_options.D);
end

end