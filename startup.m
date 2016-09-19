function startup(BaseDirectory)

% Startup_MSVD adds the various directories used by the diffusion geometry code
% to the current path.  DGPaths will assume the current directory is the
% base directory unless another directory is specified


fprintf('Startup_MSVD.m: setting MultiscaleSVD paths ... \n');

if nargin==0
    Prefix  = [pwd filesep];
else
    Prefix  = [BaseDirectory filesep];
end;

% choose your nearest neighbors code by changing this line
appendpath(([Prefix 'functions']));

return;

function appendpath(string)

fprintf('\t%s\\ \n', string);
addpath(genpath(string));

return;