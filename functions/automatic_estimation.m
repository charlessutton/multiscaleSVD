function [ k ] = automatic_estimation(data, algo_options)

% This function estimates the intrinsic dimension from the
% dataset
% inputs : Dataset ( n * D)
% ouputs : estimation of the intrinsic dimensionnality

n = size(data,1);
D = size(data,2);

dm = distance_matrix(data); %Compute the distance matrix
r_min = max(min(dm));
r_max = max(max(dm));
pas = (r_max-r_min)/1000;
all_radius = r_min:pas:r_max; % first select a wide range of radius
avg_vector = zeros(1,length(all_radius));
for i = 1:length(all_radius)
    avg_vector(i) = avg_nb_per_ball(dm,all_radius(i));
end

% choosing bounds for intelligent radiuses
avg_nb_min = 3; % minimum neighbors accepted
avg_nb_max = max(avg_vector);
steps = linspace(3,avg_nb_max,algo_options.it);
steps = [steps(1:length(steps)-2),linspace(steps(length(steps)-1),steps(length(steps)),algo_options.it_end)];

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

% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);

% Multiscale in progress
Eeigenval = zeros(min(n,D),length(radius));
for i = 1:length(radius)
    r = radius(i);
    for j = 1:n
        nb_n = find(sd_m(j,:) > r ,1); %find the number of neighbors
        n_idx = nn_m(j,1:nb_n); %get indices of these neighbors
        ball_z_r = data(n_idx,:); 
        ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
        local_eigval = svd(ball_z_r');
        Eeigenval(1:size(local_eigval,1),i) = Eeigenval(1:size(local_eigval,1),i) + local_eigval; %column vector %sum of eigvals
    end
    Eeigenval(:,i) = Eeigenval(:,i) / n;  
end
Eeigenval = Eeigenval./sqrt(n); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)

k = estimate_dim(Eeigenval);
end