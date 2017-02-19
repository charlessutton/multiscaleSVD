%% Parameters data
clear all
data_options = struct();
data_options.type = 'triangle';
data_options.noise_level = 0.05;
data_options.k = 5;
data_options.n = 1000;
data_options.D = 100;
data_options.gain = 'off';
data_options.circular = 'on';
data_options.width = 0.1;
%% Parameters algo
algo_options = struct('it',8,'it_end',3,'it_start',10,'subsample',true,'sqrt_subsampling',10);
%% Generate data
noisy_data = generate_data(data_options);
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
%% choosing bounds for intelligent plotting radiuses
avg_nb_min = 1; % minimum neighbors accepted
avg_nb_max = max(avg_vector);
steps = [linspace(1,50,algo_options.it_start), linspace(60,avg_nb_max, algo_options.it)]; %adding steps in the most important region
steps = [steps(1:length(steps)-2),linspace(steps(length(steps)-1),steps(length(steps)),algo_options.it_end)]; %adding steps in the most important region

radius = zeros(length(steps)+1,1); %efficient selection of radius
avg_nn = zeros(length(steps),1); %efficient selection of radius

for i=1:length(steps)
    threshold = steps(i);
    ix = find(avg_vector>threshold,1);
    if isempty(ix)
        radius(i) = all_radius(length(all_radius));
        avg_nn(i) = avg_vector(length(all_radius));
    else
        radius(i) = all_radius(ix);
        avg_nn(i) = avg_vector(i);
    end
end

% adding radii to see global svd SV
radius(length(steps)) = 1.05 * r_max;
radius(length(steps)+1) = 1.1 * r_max;

avg_nn(length(steps)) = avg_vector(length(all_radius));
%% nb neighbors wrt radius
figure;
plot(all_radius,avg_vector)
hold on
scatter(radius',zeros(length(radius),1),'filled');
title('Average nb of neighbors, wrt the radius');
xlabel('radius');
nb_neighbors = 20;
relevant_radius = all_radius(find(avg_vector > nb_neighbors, 1));
fprintf('\n relevant radius : %d \n ', relevant_radius);
%% some points
for ii=1:1
    figure;
    plot(noisy_data(ii,:))
    title( sprintf('%s pulses with dim %d ' , data_options.type, data_options.k));
end

%% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);
%% processing multiscale svd
disp('Multiscale in progress ...')

Eeigenval = zeros(min(data_options.n,data_options.D),length(radius));
Stdeigenval = zeros(min(data_options.n,data_options.D),length(radius));

for i = 1:length(radius)
%    local_eigval_matrix = zeros(min(data_options.n,data_options.D),data_options.n);
    local_eigval_matrix = zeros(min(data_options.n,data_options.D), algo_options.sqrt_subsampling*round(sqrt(data_options.n)));
    subsample_idx = randsample(data_options.n, algo_options.sqrt_subsampling*round(sqrt(data_options.n)));
    r = radius(i);
    if r < r_max
        %case r is small enough to perform local svd
        if  algo_options.subsample
            for j = subsample_idx'
                nb_n = find(sd_m(j,:) > r ,1); %find the number of neighbors
                n_idx = nn_m(j,1:nb_n); %get indices of these neighbors
                ball_z_r = noisy_data(n_idx,:);
                ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
                local_eigval = svd(ball_z_r');
                local_eigval_matrix(1:size(local_eigval,1),j) = local_eigval;
            end
        else
            for j = 1:data_options.n
                nb_n = find(sd_m(j,:) > r ,1); %find the number of neighbors
                n_idx = nn_m(j,1:nb_n); %get indices of these neighbors
                ball_z_r = noisy_data(n_idx,:);
                ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
                local_eigval = svd(ball_z_r');
                local_eigval_matrix(1:size(local_eigval,1),j) = local_eigval;
            end
        end
        for k = 1:min(data_options.n,data_options.D)
            sv_vec = local_eigval_matrix(k,:);
            Eeigenval(k,i) = mean(sv_vec(sv_vec>0));
            if isnan(Eeigenval(k,i))
                Eeigenval(k,i)= 0;
            end
            Stdeigenval(k,i) = std(sv_vec(sv_vec>0));
            if isnan(Stdeigenval(k,i))
                Stdeigenval(k,i) = 0;
            end
        end
    else
        %case global svd
        global_ball = noisy_data;
        global_ball = bsxfun(@minus,global_ball,mean(global_ball,1)); % we center the data
        global_eigval = svd(global_ball);
        Eeigenval(1:size(global_eigval,1),i) = global_eigval;
    end
    
end

Eeigenval = Eeigenval./sqrt(data_options.n); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)
Stdeigenval = Stdeigenval./sqrt(data_options.n);

disp('done')

%  Plotting results
disp('Plotting')
y = data_options.k + 20;
figure;
for i = 1:y
    plot([0,radius'],[0,Eeigenval(i,:)],'-b')
    hold on
    plot([0,radius'],[0,Eeigenval(i,:)+Stdeigenval(i,:)],':k')
    hold on
    plot([0,radius'],[0,Eeigenval(i,:)-Stdeigenval(i,:)],':r')
    hold on
end
ax = gca();
pmax = plot([r_max, r_max],ax.YLim, '-m');
hold on
scatter(radius',zeros(length(radius),1),'filled');
hold on

%for r=radius(1:algo_options.it+1)
%    pmax = plot([r,r],[0, ax.YLim(1)], '-m');
%    hold on
%end
%legend(pmax , 'global SVD values', 'Location','best')
title( sprintf('MSVD %s pulses with dim %d ' , data_options.type, data_options.k));
xlabel('radius') % x-axis label
ylabel('$$ E_{z}\left[\sigma_{i}\left(z,r\right)\right] $$', 'Interpreter', 'latex') % y-axis label

%% Estimations
estimation = estimate_dim(Eeigenval);
w_estimation = estimate_dim_decreasing_weight(Eeigenval, radius, algo_options);
eigenvalues = svd(noisy_data);
fprintf('\n estimated dimension (with weights) : %d', w_estimation);
fprintf('\n estimated dimension : %d', estimation);
fprintf('\n estimated dimension (global SVD) : %d', find(eigenvalues<0.001,1));
fprintf('\n true dimension : %d \n ', data_options.k);


