%This script illustrates the multiscale svd technique on curve balls

%% Initialization
rng(55555)
k = 3;          %intrinsic dimension
D = 1000;        % nr of sample points for each curve ball 
n = 500;       % nb of samples
pulse_sigma = 0.1;    % var of the noise( recall : var = std ^ 2 and std = 0.1 in the paper)
noise_sigma = 0; 
y = 20 ; % nb of eigenvalues to be sure to have intrinsic + curvatures + noise effects on the same plot see section 3.3 of the article
it = 15;        %number of scales tested (nb of iterations)
it_end = 5;
I = linspace(0,k,D);
r_prop = 1; % choose a value in [0.6,0.95] regarding the data 
%% generating uncorrupted data set
% noisy_data = generate_pulse_kD(k, n, D, pulse_sigma , noise_sigma);
%noisy_data = generate_sphere(k,D,n,noise_sigma);
noisy_data = generate_concat_pulse_1D(k, n, D, pulse_sigma, noise_sigma );

%% assessing well generation
figure;
for i = 1:5 
    %plot(I,noisy_data(i,:));
    plot(noisy_data(i,:));
    hold on
end
%% efficiently choosing the set of radius
dm = distance_matrix(noisy_data); %Compute the distance matrix
r_min = max(min(dm));
r_max = max(max(dm));
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
steps = [steps(1:length(steps)-2),linspace(steps(length(steps)-1),steps(length(steps)),it_end)];

radius = zeros(length(steps),1); %efficient selection of radius
for i=1:length(steps)
   threshold = steps(i);   
   ix = find(avg_vector>threshold,1);
   if isempty(ix)
        radius(i) = all_radius(length(all_radius));    
   else 
        radius(i) = all_radius(ix);
   end
   
end

radius = radius(1:length(radius)-1);
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

