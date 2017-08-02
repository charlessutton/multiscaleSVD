% This is a script to test best_scale.m
%% Parameters data
clear all
close all
clc
tic
data_options = struct();
data_options.type = 'stair';
data_options.noise_level = 0;
data_options.k = 5;
data_options.n = 5000;
data_options.D = 200;
data_options.gain = 'off';
data_options.circular = 'on';
data_options.width = 0.05;

data_options.neigh = 1000;
data_options.tries = 50;


%% local linearity , finding "the best scale" by moving a single sample

[radius, spread, ratio] = best_scale(data_options, 0.9)
