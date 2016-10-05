%% Choose example
clear all
% This file runs all examples of the presentation / report and creates corresponding figures 
% Execute 'clear all' before running the script, otherwise it will re-run with any existing options without prompting the user.

%TO DO :
% add timing information
% add examples

% list of examples
examples   = { '9-d sphere without noise', ...
    '9-d sphere with little noise', ...
    '1-D gaussian pulse without noise', ...
    '1-D gaussian pulse with noise', ...
    '3 concatenated 1D gaussian pulse', ...
    '3 concatenated 1D gaussian pulse, noisy case', ...
    '5 concatenated 1D gaussian pulse', ...
    '5 concatenated 1D gaussian pulse, noisy case', ...
    '5 summed 1D gaussian thin pulse', ...
    '5 summed 1D gaussian thick pulse', ...
    '1D stair pulse without noise', ...
    '5 summed 1D stair pulses', ...
    '5 concatenated 1D stair pulses'
    };

fprintf('\n\n Select example to run:\n');
for k = 1:length(examples),
    fprintf('\n [%d] %s',k,examples{k});
end;
fprintf('\n\n  ');

while true,
    if (~exist('example_id') || isempty(example_id) || example_id==0),
        try
            example_id = input('');
            example_id = str2num(example_id);
        catch
        end;
    end;
    if (example_id>=1) && (example_id<=length(examples)),
        break;
    else
        fprintf('\n %d is not a valid Example. Please select a valid Example above.',example_id);
        example_id=0;
    end;
end;

%% Generate data of the chosen example
algo_options = struct('it',15,'it_end',5,'sqrt_subsampling',3);
switch example_id
    case 1
        data_options = struct('type','sphere','n',1000,'D',100,'k',9,'sigma_noise',0,'seed',555);
    case 2
        data_options = struct('type','sphere','n',1000,'D',100,'k',9,'sigma_noise',0.1,'seed',555);
    case 3
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',1,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 4
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',1,'sigma_noise',0.1,'sigma_pulse',0.1,'seed',555);
    case 5
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',3,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 6
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',3,'sigma_noise',0.01,'sigma_pulse',0.1,'seed',555);
    case 7
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 8
        data_options = struct('type','gaussian_pulse_concat','n',1000,'D',1000,'k',5,'sigma_noise',0.01,'sigma_pulse',0.1,'seed',555);
    case 9
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.01,'seed',555);
    case 10
        data_options = struct('type','gaussian_pulse_sum','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 11
        data_options = struct('type','stair_sum','n',1000,'D',1000,'k',1,'sigma_noise',0.01,'sigma_pulse',0.1,'seed',555);
    case 12
        data_options = struct('type','stair_sum','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.1,'seed',555);
    case 13
        data_options = struct('type','stair_concat','n',1000,'D',1000,'k',5,'sigma_noise',0,'sigma_pulse',0.05,'seed',555);
end
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

%% choosing bounds for intelligent radiuses
avg_nb_min = 3; % minimum neighbors accepted
avg_nb_max = max(avg_vector);
steps = linspace(3,avg_nb_max,algo_options.it);
steps = [steps(1:length(steps)-2),linspace(steps(length(steps)-1),steps(length(steps)),algo_options.it_end)]; %adding steps in the most important region
radius = zeros(length(steps)+1,1); %efficient selection of radius

for i=1:length(steps)
   threshold = steps(i);   
   ix = find(avg_vector>threshold,1);
   if isempty(ix)
        radius(i) = all_radius(length(all_radius));    
   else 
        radius(i) = all_radius(ix);
   end 
end

% adding radii to see global svd SV
radius(length(steps)) = 1.1 * r_max;
radius(length(steps)+1) = 1.3 * r_max; 
%% Computing nearest neighbors
[sd_m, nn_m] = NN_matrices(dm);
%% processing multiscale svd
disp('Multiscale in progress ...')

Eeigenval = zeros(min(data_options.n,data_options.D),length(radius));
Stdeigenval = zeros(min(data_options.n,data_options.D),length(radius));

for i = 1:length(radius)
    %local_eigval_matrix = zeros(min(data_options.n,data_options.D),data_options.n);
    local_eigval_matrix = zeros(min(data_options.n,data_options.D), algo_options.sqrt_subsampling*round(sqrt(data_options.n)));
    r = radius(i);
    if r < r_max
        %case r is small enough to perform local svd
        %for j = 1:data_options.n
        subsample_idx = randsample(data_options.n, algo_options.sqrt_subsampling*round(sqrt(data_options.n)));
        for j = subsample_idx' 
            nb_n = find(sd_m(j,:) > r ,1); %find the number of neighbors
            n_idx = nn_m(j,1:nb_n); %get indices of these neighbors
            ball_z_r = noisy_data(n_idx,:); 
            ball_z_r = bsxfun(@minus,ball_z_r,mean(ball_z_r,1)); % we center the data
            local_eigval = svd(ball_z_r');
            local_eigval_matrix(1:size(local_eigval,1),j) = local_eigval;
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

%%  Plotting results
disp('Plotting')
y = data_options.k + 200;
figure;
for i = 1:y
    plot([0,radius'],[0,Eeigenval(i,:)],'-b')
    hold on
    plot([0,radius'],[0,Eeigenval(i,:)+Stdeigenval(i,:)],':k')
    hold on
    plot([0,radius'],[0,Eeigenval(i,:)-Stdeigenval(i,:)],':r')
    hold on
end
title(examples(example_id));
xlabel('radius') % x-axis label
ylabel('$$ E_{z}\left[\sigma_{i}\left(z,r\right)\right] $$', 'Interpreter', 'latex') % y-axis label

%% Estimated intrinsic dimension
estimation = estimate_dim(Eeigenval);
fprintf('\n estimated dimension : %d', estimation);
fprintf('\n true dimension : %d \n ', data_options.k);
