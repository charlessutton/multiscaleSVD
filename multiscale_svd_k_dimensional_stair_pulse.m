%This script illustrates the multiscale svd technique on curve balls

%% Initialization
rng(55555)
k = 5;          %intrinsic dimension
D = 1000;        % nr of sample points for each curve ball 
n = 500;       % nb of samples
pulse_width = 0.1;    % var of the noise( recall : var = std ^ 2 and std = 0.1 in the paper)
noise_sigma = 0.1; 
y = 30 ; % nb of eigenvalues to be sure to have intrinsic + curvatures + noise effects on the same plot see section 3.3 of the article
it = 15;        %number of scales tested (nb of iterations)
I = linspace(0,1,D);
r_prop = 0.90; % choose a value in [0.6,0.95] regarding the data 
%% generating uncorrupted data set
noisy_data = generate_stair_pulse_kD(k, n, D, pulse_width , noise_sigma);
%% assessing well generation
figure;
for i = 1:5 
    plot(I,noisy_data(i,:));
    hold on
end
%% efficiently choosing the set of radius
dm = distance_matrix(noisy_data); %Compute the distance matrix
r_min = max(min(dm));
r_max = min(max(dm));
pas = (r_max-r_min)/1000;
all_radius = r_min:pas:r_max; % first select a wide range of radius
avg_vector = zeros(1,length(all_radius));
for i = 1:length(all_radius)
    avg_vector(i) = avg_nb_per_ball(dm,all_radius(i));
end
%% see the distribution of avg number of neighbors
figure;
plot(1:length(avg_vector),avg_vector)
%% choosing bounds for intelligent radiuses
avg_nb_min = 3; % minimum neighbors accepted
avg_nb_max = r_prop*max(avg_vector);
steps = linspace(3,avg_nb_max,it);
radius = zeros(it,1); %efficient selection of radius
for i=1:length(steps)
   threshold = steps(i);   
   ix = find(avg_vector>threshold,1);
   radius(i) = all_radius(ix);
end
%% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);
%% processing multiscale svd
disp('Multiscale in progress ...')
Eeigenval = zeros(min(n,D),length(radius));
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
%Eeigenval(:,length(radius)+1) = svd(noisy_data);
Eeigenval = Eeigenval./sqrt(n); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)
disp('done')
%%  Plotting results
disp('Plotting')
figure
for i = 1:y
    plot([0,radius'],[0,Eeigenval(i,:)])
    hold on
end