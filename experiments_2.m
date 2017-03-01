% This is my main script to perform experiments : selecting the type of pulses and get MSVD plots 
%% Parameters data
clear all
clc
tic
data_options = struct();
data_options.type = 'gaussian';
data_options.noise_level = 0;
data_options.k = 3;
data_options.n = 2000;
data_options.D = 50;
data_options.gain = 'on';
data_options.circular = 'on';
data_options.width = 0.05;

data_options.neigh = 1000;
data_options.mu = rand(1,data_options.k);

%% Parameters algo
radius_options = struct('it',7,'it_end',2,'it_start',4);

%% Subsampling options 
sub_options = struct('state',true,'nb',200);

%% Plotting options
plt_options = struct('sample',false,'avg',false,'msvd',true);

%% Generating dataset of pulses 
noisy_data = generate_data(data_options);

%% local linearity , finding "the best scale" by moving a single sample

epsilons = 0.0001 * exp(1).^(1:11); 

ratio = zeros(1,length(epsilons));
avg_distance = zeros(1,length(epsilons));

for i = 1:length(epsilons)
    data_options.epsilon = epsilons(i);
    data = generate_neighs(data_options);
    sv = svd(data);
    ratio(i) = sum(sv(1:data_options.k))/sum(sv);
    DM = squareform(pdist(data));
    avg_distance(i) = mean(DM(1,2:data_options.neigh+1));
end

threshold = 0.80 ;
lin_index = find(ratio<threshold,1) - 1;
eps_lin_max = epsilons(lin_index);

options.epsilon = eps_lin_max;
data = generate_neighs(data_options);
DM = squareform(pdist(data));
average_distance = mean(DM(1,2:data_options.neigh+1));

%% choosing radii
dm = distance_matrix(noisy_data); %Compute the distance matrix
r_min = max(min(dm));
r_max = min(max(dm));
r_max_max = max(max(dm));
pas = (r_max_max-r_min)/50 ;
all_radius = r_min:pas:r_max_max; % first select a wide range of radius
avg_vector = zeros(1,length(all_radius));

for i = 1:length(all_radius)
    avg_vector(i) = avg_nb_per_ball(dm,all_radius(i));
end

radius = [ avg_distance(1:lin_index-2), ...
    linspace(avg_distance(lin_index-1),avg_distance(lin_index),radius_options.it_start), ...
    linspace(avg_distance(lin_index),r_max,radius_options.it), ...
    linspace(r_max,r_max_max,radius_options.it_end)] ;

radius = unique(radius); % to delete doublons

%% nb neighbors wrt radius

if plt_options.avg
    figure;
    plot(all_radius,avg_vector)
    hold on
    scatter(radius',zeros(length(radius),1),'filled');
    hold on
    pmax = scatter(radius(lin_index),0, 'filled');
    title('Average nb of neighbors, wrt the radius');
    xlabel('radius');
    nb_neighbors = 20;
    relevant_radius = all_radius(find(avg_vector > nb_neighbors, 1));
    fprintf('\n relevant radius : %d \n ', relevant_radius);
end
%% to get the approximate number of neighbors at the best scale
avg_nb_neighbors = zeros(1,length(radius));
for r = 1:length(radius)-1
   r_idx = find(all_radius>radius(r),1);
   avg_nb_neighbors(r) = round(avg_vector(r_idx));
end
avg_nb_neighbors(length(radius)) = data_options.n; 


[avg_nb_neighbors(lin_index) , radius(lin_index )]

%% some points
if plt_options.sample
    I = linspace(0,1,data_options.D);
    for ii=1:1
        figure;
        plot(I, noisy_data(ii,:))
        title( sprintf('%s pulses with dim %d ' , data_options.type, data_options.k));
    end
end
%% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);

%% processing multiscale svd
disp('Multiscale in progress ...')

Eeigenval = zeros(min(data_options.n,data_options.D),length(radius));
Stdeigenval = zeros(min(data_options.n,data_options.D),length(radius));

if sub_options.state
    [~,~,~,~,subsample_idx] = kmedoids(noisy_data, sub_options.nb); % kmedoids + subsample idx   

    for i = 1:length(radius)

        local_eigval_matrix = zeros(min(data_options.n,data_options.D),sub_options.nb);
        r = radius(i);
        if r < r_max %case r is small enough to perform local svd


            for j = 1:sub_options.nb
                nb_n = find(sd_m(subsample_idx(j),:) > r ,1); %find the number of neighbors
                n_idx = nn_m(subsample_idx(j),1:nb_n); %get indices of these neighbors
                ball_z_r = noisy_data(n_idx,:);
                ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
                local_eigval = svd(ball_z_r');
                local_eigval_matrix(1:size(local_eigval,1),j) = local_eigval;
            end
            for l = 1:min(data_options.n,data_options.D)
                sv_vec = local_eigval_matrix(l,:);
                Eeigenval(l,i) = mean(sv_vec);
                if isnan(Eeigenval(l,i))
                    Eeigenval(l,i)= 0;
                end
                Stdeigenval(l,i) = std(sv_vec);
                if isnan(Stdeigenval(l,i))
                    Stdeigenval(l,i) = 0;
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

    
    Eeigenval = Eeigenval./sqrt(sub_options.nb); %rescale to fit with the article where they use the matrix X * 1 / sqrt(n)
    Stdeigenval = Stdeigenval./sqrt(sub_options.nb);
else   
    for i = 1:length(radius)

        local_eigval_matrix = zeros(min(data_options.n,data_options.D),data_options.n);
        r = radius(i);
        if r < r_max %case r is small enough to perform local svd


            for j = 1:data_options.n
                nb_n = find(sd_m(j,:) > r ,1); %find the number of neighbors
                n_idx = nn_m(j,1:nb_n); %get indices of these neighbors
                ball_z_r = noisy_data(n_idx,:);
                ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
                local_eigval = svd(ball_z_r');
                local_eigval_matrix(1:size(local_eigval,1),j) = local_eigval;
            end
            for l = 1:min(data_options.n,data_options.D)
                sv_vec = local_eigval_matrix(l,:);
                %Eeigenval(k,i) = mean(sv_vec(sv_vec>0)); %
                Eeigenval(l,i) = mean(sv_vec);
                if isnan(Eeigenval(l,i))
                    Eeigenval(l,i)= 0;
                end
                %Stdeigenval(k,i) = std(sv_vec(sv_vec>0));
                Stdeigenval(l,i) = std(sv_vec);
                if isnan(Stdeigenval(l,i))
                    Stdeigenval(l,i) = 0;
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
end
disp('done')

%  Plotting results
disp('Plotting')
y = min(data_options.n,data_options.D);
if plt_options.msvd
    figure;
    for i = 1:y
        plot([0,radius],[0,Eeigenval(i,:)],'-b')
        hold on
        plot([0,radius],[0,Eeigenval(i,:)+Stdeigenval(i,:)],':k')
        hold on
        plot([0,radius],[0,Eeigenval(i,:)-Stdeigenval(i,:)],':r')
        hold on
    end
    ax = gca();
    pmax = plot([r_max, r_max],ax.YLim, '-m');
    hold on
    rbest = plot([radius(lin_index), radius(lin_index)],ax.YLim, '-g');
    hold on
    scatter(radius,zeros(length(radius),1),'filled');
    hold on
    
    title( sprintf('MSVD %s pulses with dim %d ' , data_options.type, data_options.k));
    xlabel('radius') % x-axis label
    ylabel('$$ E_{z}\left[\sigma_{i}\left(z,r\right)\right] $$', 'Interpreter', 'latex') % y-axis label
end
toc