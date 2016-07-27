%This script illustrates the multiscale svd technique on the noisy sphere
%just as it is described in the section 2.1 of the paper "multiscale estimation of intrinsic
%dimensionality of data sets" Maggioni and al. 

%initialization
rng(12345)
k = 9;          %intrinsic dimension
D = 100;         % ambiant dimension
n = 1000 ;       % nb of samples
sigma = 0.01;    % var of the noise( recall : var = std ^ 2 and std = 0.1 in the paper)
y = k + k*(k+1)/2 + 1 ; % nb of eigenvalues to be sure to have intrinsic + curvatures + noise effects on the same plot see section 3.3 of the article
radius = 0:0.01:2.5     ; % r to perform multiscale SVD

%generating corrupted data (noisy sphere)
noisy_data = generate_sphere(k,D,n,sigma);

Eeigenval = [];

disp('Multiscale in progress ...')
for r = radius
    Eeigenval = [Eeigenval, local_svd(noisy_data,r)]; %matrix where we concatenate column by column the sorted listed of Eeigenval for a given radius
end

Eeigenval = Eeigenval/sqrt(n); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)

disp('Plotting')
figure
for i = 1:y
    plot(radius,Eeigenval(i,:))
    hold on
end