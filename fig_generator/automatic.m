% This is my main script to perform experiments : selecting the type of pulses and get MSVD plots 
%% Parameters data
clear all
close all
clc

% main_dir = 'C:\\Users\\sutton\\Google Drive\\Thesis\\figures\\automatic\\';
main_dir = '/Users/Code/Google Drive/thesis/figures/automatic/'; % mac

formatOut = 'yy_mm_dd_HH_MM';
date_str = datestr(now,formatOut);

% cat(2,main_dir,date_str,'\\'); % concat deux strings

for type_params = 1:3
     
for k_params = 1:5

for noise_params = 1:4

tic

data_options = struct();
switch type_params
    case 1 
        data_options.type = 'gaussian';
    case 2
        data_options.type = 'triangle';
    case 3
        data_options.type = 'stair';
end
switch noise_params
    case 1
        data_options.noise_level = 0;
        noise_name = 'clean';
    case 2
        data_options.noise_level = 0.1;
        noise_name = 'low_noise';
    case 3
        data_options.noise_level = 0.5;
        noise_name = 'mid_noise';
    case 4
        data_options.noise_level = 1;
        noise_name = 'high_noise';
end
expname = cat(2,'_',noise_name);
        
data_options.k = k_params;

data_options.n = 10000;
data_options.D = 200;
data_options.gain = 'off';
data_options.circular = 'on';
switch data_options.type 
    case 'gaussian'
        data_options.width = 0.05;
    case 'triangle'
        data_options.width = 0.2;
    case 'stair'
        data_options.width = 0.1;
end  
data_options.neigh = 1000;
data_options.tries = 50;

% foldername = cat(2,main_dir,date_str,'\\',data_options.type,'\\',num2str(data_options.k),'\\',noise_name,'\\');
foldername = cat(2,main_dir,date_str,'/',data_options.type,'/',num2str(data_options.k),'/',noise_name,'/');
mkdir(foldername);
diary(cat(2,foldername,'console_outputs.txt'));
diary on

%% Parameters algo
radius_options = struct('it',5,'it_end',2,'it_start',5,'it_mid',4);

%% Subsampling options 
sub_options = struct('state',true,'nb',round(sqrt(data_options.n)));

%% Plotting options
plt_options = struct('sample',true,'avg',true,'msvd',true,'rmsvd',true);

%% Generating dataset of pulses 
noisy_data = generate_data(data_options);

%% some key radii
dm = distance_matrix(noisy_data); %Compute the distance matrix

r_min = max(min(dm));
r_max = min(max(dm));
r_max_max = max(max(dm));
pas = (r_max_max-r_min)/50 ;
all_radius = r_min:pas:r_max_max; % first select a wide range of radius

%% finding the relevant scale for this manifold
[relevant_scale, spread, epsilon] = best_scale(data_options, 0.95);
data_options.epsilon = epsilon;

radius = [ linspace(0,relevant_scale-spread,radius_options.it_start), ...
    linspace(relevant_scale-spread, relevant_scale+spread, radius_options.it), ...
    linspace(relevant_scale+spread,r_max,radius_options.it_mid), ...
    linspace(r_max,r_max_max,radius_options.it_end)] ;

radius = unique(radius); % to delete doublons

%% 
avg_vector = zeros(1,length(all_radius));
for i = 1:length(all_radius)
    avg_vector(i) = avg_nb_per_ball(dm,all_radius(i));
end

%% nb neighbors wrt radius

if plt_options.avg
    figure;
    plot(all_radius,avg_vector)
    hold on
    scatter(radius',zeros(length(radius),1),'filled');
    hold on
    pmax = scatter(relevant_scale,0, 'filled');
    title('Average nb of neighbors, wrt the radius');
    xlabel('radius');
    nb_neighbors = 20;
    relevant_radius = all_radius(find(avg_vector > nb_neighbors, 1));
    fprintf('\n relevant radius : %d \n ', relevant_radius);
end

filename = sprintf('%s_%d_avg_neigh' , data_options.type, data_options.k);
saveas(gcf, cat(2,foldername,filename,expname), 'jpg');

%% to get the approximate number of neighbors at the best scale
r_idx = find(all_radius > relevant_scale,1);
% avg_nb_neighbors = zeros(1,length(radius));
fprintf('Avg Nb of neighbors at relevant scale : %d \n' , round(avg_vector(r_idx)));
data_options.avg_nb_neighbors = round(avg_vector(r_idx));
%% some points
if plt_options.sample
    I = linspace(-1,1,data_options.D);
    for ii=1:1
        figure;
        plot(I, noisy_data(ii,:))
        title( sprintf('%s pulses with dim %d ' , data_options.type, data_options.k));
        filename = sprintf('%s_%d_sample_%d' , data_options.type, data_options.k, ii);
        saveas(gcf, cat(2,foldername,filename,expname), 'jpg');
    end
end
%% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);

%% processing multiscale svd
disp('Multiscale in progress ...')

Eeigenval = zeros(min(data_options.n,data_options.D),length(radius));
EReigenval = zeros(min(data_options.n,data_options.D),length(radius));
Stdeigenval = zeros(min(data_options.n,data_options.D),length(radius));
StdReigenval = zeros(min(data_options.n,data_options.D),length(radius));

if sub_options.state
    [~,~,~,~,subsample_idx] = kmedoids(noisy_data, sub_options.nb); % kmedoids + subsample idx   

    for i = 1:length(radius)

        local_eigval_matrix = zeros(min(data_options.n,data_options.D),sub_options.nb);
        local_relative_eigval_matrix = zeros(min(data_options.n,data_options.D),sub_options.nb);
        r = radius(i);
        if r < r_max %case r is small enough to perform local svd


            for j = 1:sub_options.nb
                nb_n = find(sd_m(subsample_idx(j),:) > r ,1); %find the number of neighbors
                n_idx = nn_m(subsample_idx(j),1:nb_n); %get indices of these neighbors
                ball_z_r = noisy_data(n_idx,:);
                ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
                local_eigval = svd(ball_z_r');
                local_eigval_matrix(1:size(local_eigval,1),j) = local_eigval;
                local_relative_eigval_matrix(1:size(local_eigval,1),j) = local_eigval/local_eigval(1); % relative weights of eigvals
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
                
                rsv_vec = local_relative_eigval_matrix(l,:);
                EReigenval(l,i) = mean(rsv_vec);
                if isnan(EReigenval(l,i))
                    EReigenval(l,i)= 0;
                end
                StdReigenval(l,i) = std(rsv_vec);
                if isnan(StdReigenval(l,i))
                    StdReigenval(l,i) = 0;
                end                
            end
        else
            %case global svd
            global_ball = noisy_data;
            global_ball = bsxfun(@minus,global_ball,mean(global_ball,1)); % we center the data
            global_eigval = svd(global_ball);
            Eeigenval(1:size(global_eigval,1),i) = global_eigval;
            EReigenval(1:size(global_eigval,1),i) = global_eigval/global_eigval(1);
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
    rbest = plot([relevant_scale, relevant_scale],ax.YLim, '-g');
    hold on
    scatter(radius,zeros(length(radius),1),'filled');
    hold on
    
    title( sprintf('MSVD %s pulses with dim %d ' , data_options.type, data_options.k));
    xlabel('radius') % x-axis label
    ylabel('$$ E_{z}\left[\sigma_{i}\left(z,r\right)\right] $$', 'Interpreter', 'latex') % y-axis label
end

filename = sprintf('%s_%d_kmsvd' , data_options.type, data_options.k);
saveas(gcf, cat(2,foldername,filename,expname), 'jpg');

if plt_options.rmsvd
    figure;
    for i = 1:y
        plot([0,radius],[0,EReigenval(i,:)],'-b')
        hold on
        plot([0,radius],[0,EReigenval(i,:)+StdReigenval(i,:)],':k')
        hold on
        plot([0,radius],[0,EReigenval(i,:)-StdReigenval(i,:)],':r')
        hold on
    end
    ax = gca();
    pmax = plot([r_max, r_max],ax.YLim, '-m');
    hold on
    rbest = plot([relevant_scale, relevant_scale],ax.YLim, '-g');
    hold on
    scatter(radius,zeros(length(radius),1),'filled');
    hold on
    ylim([0, 1.1])
    title( sprintf('Relative MSVD %s pulses with dim %d ' , data_options.type, data_options.k));
    xlabel('radius') % x-axis label
    ylabel('$$ E_{z}\left[\sigma_{i}\left(z,r\right)\right] / E_{z}\left[\sigma_{1}\left(z,r\right)\right] $$', 'Interpreter', 'latex') % y-axis label
end


filename = sprintf('%s_%d_rmsvd' , data_options.type, data_options.k);
saveas(gcf, cat(2,foldername,filename,expname), 'jpg');

toc

diary off
writetable(struct2table(data_options),cat(2,foldername,'data_options.txt'))

close all
clc

end
end
end