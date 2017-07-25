%% Index 

% Gaussian signal


%% Gaussian signal 

D = 20000;
I = linspace(-1,1,D);
k = 2;
sigma = 0.05;
seeds_2 = [50, 677, 825, 1282, 555, 123, 888]; % classic, collision, single peak, circularity
seeds_3 = [1122, 1393, 2259, 1176]; % classic, two peaks, one peak ,circularity
seeds_4 = [2995, 1911, 2141, 695, 1019, 1127];

for seed = seeds_2
%for l = 1:20
%    seed = randi(3000);
    rng(seed);
    mu = sort(2*rand(1,k) - 1) ;
        
    half_width = norminv(0.9999,0,sigma); 
    half_width_sample = round(0.5*half_width * D);
    I_extended = linspace(-1 - half_width , 1 + half_width , D + 2*half_width_sample);
    
    pulse_extended = zeros(1, D + 2*half_width_sample);
        
    for i = 1:k
        pulse_extended(1,:) = pulse_extended(1,:) + normpdf(I_extended, mu(i), sigma);
    end

    pulse = zeros(1,D);
    pulse = pulse_extended(:,half_width_sample+1:D + half_width_sample); 
    pulse(:,1:half_width_sample) = pulse(:,1:half_width_sample) + pulse_extended(:,D + half_width_sample+1 : D + 2*half_width_sample);
    pulse(:, D - half_width_sample + 1 : D ) = pulse(:, D - half_width_sample + 1 : D ) + pulse_extended(:, 1 : half_width_sample );

    % neigh music (we plot it before it is more explactive)
    
    neigh_noise = pulse + 0.2*randn(1,D);
    figure;
    plot(I,neigh_noise,'green');
    hold on 
    
    % original pulse
    plot(I,pulse,'blue', 'LineWidth', 2);
    hold on 
%     
%     for i = 1:k
%         plot([mu(i), mu(i)], [0,pulse(find(I>mu(i),1))], 'green' );
%         text(mu(i),-1, sprintf('\\theta_{%d}',i), 'FontSize', 8);
%         hold on 
%     end
%    
    % neigh using noise on parameter
    
    mu_neigh = mu + 0.05 * randn(1,k);
    neigh_extended = zeros(1, D + 2*half_width_sample);
        
    for i = 1:k
        neigh_extended(1,:) = neigh_extended(1,:) + normpdf(I_extended, mu_neigh(i), sigma);
    end

    neigh = zeros(1,D);
    neigh = neigh_extended(:,half_width_sample+1:D + half_width_sample); 
    neigh(:,1:half_width_sample) = neigh(:,1:half_width_sample) + neigh_extended(:,D + half_width_sample+1 : D + 2*half_width_sample);
    neigh(:, D - half_width_sample + 1 : D ) = neigh(:, D - half_width_sample + 1 : D ) + neigh_extended(:, 1 : half_width_sample );

    
    hold on
    
    plot(I,neigh, 'red');

    hold on 
    
%     for i = 1:k
%         plot([mu_neigh(i), mu_neigh(i)], [0,neigh(find(I>mu_neigh(i),1))], 'magenta' );
%         text(mu_neigh(i),-2, sprintf('\\theta_{%d}+\\eta_{%d}',i,i), 'FontSize', 8);
%         hold on 
%     end
%     
    ax = gca;
    %ax.XTick = [-1 1];
    ylim([-1 16]);
    %title(seed)
    title(sprintf('Neighbors of a signal from the Gaussian SIPS of dimension %d',k))
    
end