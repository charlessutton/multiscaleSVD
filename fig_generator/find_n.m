%% find n to get at least 25 neighbors at the relevant scaleclear all
clear all
close all
clc

%initialisation

T = cell2table(cell(1,5),'VariableNames',{'type','dim','noise','n_sample','nb_neigh'})  ;

for type_params = 1:3     
for k_params = 1:5
for noise_params = 1:4


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
        
    case 2
        data_options.noise_level = 0.1;
        
    case 3
        data_options.noise_level = 0.5;
        
    case 4
        data_options.noise_level = 1;
   
end
        
data_options.k = k_params;

data_options.n = 5000;
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
    
% finding the relevant scale ones

enough_neighbor_flag = true;
compteur = 0; 

while enough_neighbor_flag && compteur < 5
compteur = compteur + 1
noisy_data = generate_data(data_options);    
dm = distance_matrix(noisy_data); %Compute the distance matrix

[relevant_scale, spread, epsilon] = best_scale(data_options, 0.95);

avg_nb_neighbor = avg_nb_per_ball(dm,relevant_scale);

cell_info = {data_options.type,data_options.k,data_options.noise_level,data_options.n,round(avg_nb_neighbor)};
T = [T;cell_info]
%writetable(T, '/Users/Code/Google Drive/thesis/figures/n_table.txt');
writetable(T,'C:\\Users\\sutton\\Google Drive\\Thesis\\figures\\n_table.txt');
if avg_nb_neighbor > 20 || compteur == 5
    enough_neighbor_flag = false;
else 
    data_options.n = data_options.n + 5000;
end



 
end
end
end
end