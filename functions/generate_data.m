% this function wraps all data generating functions for the project
function [data] = generate_data(data_options)
rng(data_options.seed)
switch data_options.type
    case 'sphere'
        data = generate_sphere(data_options.k,data_options.D,data_options.n,data_options.sigma_noise) ;
    case 'gaussian_pulse'
        data = generate_concat_pulse_1D(data_options.k, data_options.n, data_options.D, data_options.sigma_pulse, data_options.sigma_noise);
end