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
it = 11;        %number of scales tested (nb of iterations)

%generating corrupted data (noisy sphere)
noisy_data = generate_sphere(k,D,n,sigma);

%efficiently choosing the radius
dm = distance_matrix(noisy_data);
all_radius = 0:0.01:3; %select your range of radius
steps = linspace(3,n,it);

avg_vector = zeros(1,length(all_radius));
for i = 1:length(all_radius)
    avg_vector(i) = avg_nb_per_ball(dm,all_radius(i));
end

radius = zeros(1+it,1); %efficient selection of radius

for i=1:length(steps)-1
   threshold = steps(i);   
   ix = find(avg_vector>threshold,1);
   radius(i+1) = all_radius(ix);
end

radius(1+it) = max(all_radius);

% processing multiscale svd
Eeigenval = zeros(min(n,D),length(radius));
disp('Multiscale in progress ...')
for i = 1:length(radius)
    Eeigenval(:,i) = local_svd(noisy_data,radius(i)); %matrix where we concatenate column by column the sorted listed of Eeigenval for a given radius
end

Eeigenval = Eeigenval./sqrt(n); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)

disp('Plotting')
figure
for i = 1:y
    plot(radius,Eeigenval(i,:))
    hold on
end