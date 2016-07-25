% In this script we show on a simple example that global techniques fail to
% find the intrinsic dimensionality of a dataset

%first we generate de data with intrinsic dimensionality = 1
n = 100; % sample size
teta = 2*pi*rand(n,1); %our 1D parameter
x = cos(teta);
y = sin(teta);
z = zeros(n,1);
data = [x,y,z];

% 2D circle in a 3D ambiant space
figure
scatter3(data(:,1),data(:,2),data(:,3))
title('original data')

%SVD 
svd_clean_eigval = svd(data)

%we see that in both cases the two first eigenvalues are significantly higher than the third
%it means global PCA/SVD assume that the intrinsic dimensionality is 2 instead of 1...

% add the noise - IS THIS PART NECESSARY ??
noise = 1e-3*randn(n,3);

noisy_data = data + noise;

figure
scatter3(data(:,1),data(:,2),data(:,3))
hold on 
scatter3(noisy_data(:,1),noisy_data(:,2),noisy_data(:,3))
legend('original','corrupted')
title('data corrupted by noise')

%SVD 

svd_noisy_eigval = svd(noisy_data)

%we see that the two first eigenvalues are significantly higher than the third
%it means global SVD assume that the intrinsic dimensionality is 2 instead of 1 ...