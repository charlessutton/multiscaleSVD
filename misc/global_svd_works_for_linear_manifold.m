% In this script we show how it works for linear manifold in the orginal case
% and in the noisy case

%generate k dimensional linear manifold in a D dimensionnal space

n = 100; % sample size
k = 5;
D = 20;

%generate the linear manifold
data = zeros(n,D);
data(:,1:k) = (2*rand(n,k)-1);
% compute the eigenvalues with svd
eigenvalues_cleandata = svd(data)


%Noisy case 
%corrupt the data with gaussian noise
noise = 0.1*randn(n,D);
noisy_data = data + noise;
%compute eigenvalues with svd
eigenvalues_noisydata = svd(noisy_data)