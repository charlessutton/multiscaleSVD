% this function wraps all data generating functions for the project
function [data] = generate_data(data_options)
rng(data_options.seed)
switch data_options.type
    case 'sphere'
        data = generate_sphere(data_options.k,data_options.D,data_options.n,data_options.sigma_noise) ;
    case 'gaussian_pulse_concat'
        data = generate_concat_pulse_1D(data_options.k, data_options.n, data_options.D, data_options.sigma_pulse, data_options.sigma_noise);
    case 'gaussian_pulse_sum'
        data = generate_pulse_kD(data_options.k, data_options.n, data_options.D, data_options.sigma_pulse, data_options.sigma_noise);
    case 'stair_concat'
        data = generate_stair_pulse_concat_kD(data_options.k, data_options.n, data_options.D, data_options.sigma_pulse, data_options.sigma_noise);
    case 'stair_sum'
        data = generate_stair_pulse_kD(data_options.k, data_options.n, data_options.D, data_options.sigma_pulse, data_options.sigma_noise);
end