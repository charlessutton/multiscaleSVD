%This script illustrates the multiscale svd technique on curve balls

%% Initialization
rng(555)
k = 9;          %intrinsic dimension
D = 100;        % nr of sample points for each curve ball 
n = 100;       % nb of samples
sigma = 0.1;    % var of the noise( recall : var = std ^ 2 and std = 0.1 in the paper)
y = k + k*(k+1)/2 + 1 ; % nb of eigenvalues to be sure to have intrinsic + curvatures + noise effects on the same plot see section 3.3 of the article
it = 20;        %number of scales tested (nb of iterations)

%% generating uncorrupted data set
%dataset = zeros(n,D);
noisy_data = zeros(n,D);
rand_mu = rand(n,1);    %random mean values in the range [0,1] for the curve balls genetated
figure;
for i=1:n
    %dataset(i,:) = generate_pulse_1D(D,rand_mu(i),0);
    noisy_data(i,:) = generate_pulse_1D(D,rand_mu(i),0); %the value of n_sigma is 0 in order to generate a clean curve ball
    plot(linspace(0,1,D), noisy_data(i,:));
    hold on
end
%{
%% generating corrupted data (noisy sphere)
noisy_data = generate_sphere(k,D,n,sigma);
%}
%% efficiently choosing the set of radius
dm = distance_matrix(noisy_data); %Compute the distance matrix
all_radius = 0:0.01:3; % first select a wide range of radius
steps = linspace(3,n,it);

avg_vector = zeros(1,length(all_radius));
for i = 1:length(all_radius)
    avg_vector(i) = avg_nb_per_ball(dm,all_radius(i));
end

radius = zeros(it,1); %efficient selection of radius
for i=1:length(steps)-1
   threshold = steps(i);   
   ix = find(avg_vector>threshold,1);
   radius(i+1) = all_radius(ix);
end

r_max = max(max(dm));
%% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);


%% processing multiscale svd
disp('Multiscale in progress ...')
Eeigenval = zeros(min(n,D),length(radius)+1);

for i = 1:length(radius)
    r = radius(i);
    
    for j = 1:n
        nb_n = find(sd_m(j,:) > r ,1); %find the number of neighbors
        n_idx = nn_m(j,1:nb_n); %get indices of these neighbors
        ball_z_r = noisy_data(n_idx,:); 
        ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
        local_eigval = svd(ball_z_r');
        Eeigenval(1:size(local_eigval,1),i) = Eeigenval(1:size(local_eigval,1),i) + local_eigval; %column vector %sum of eigvals
    end
    Eeigenval(:,i) = Eeigenval(:,i) / n;  
    %old method
    %Eeigenval(:,i) = local_svd(noisy_data,radius(i)); %matrix where we concatenate column by column the sorted listed of Eeigenval for a given radius
end
Eeigenval(:,length(radius)+1) = svd(noisy_data);
Eeigenval = Eeigenval./sqrt(n); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)
disp('done')
%%  Plotting results
disp('Plotting')

figure
for i = 1:y
    plot([radius' r_max],Eeigenval(i,:))
    hold on
end