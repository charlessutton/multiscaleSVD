%% 4 dimensional gaussian pulse

%% Index 

% Gaussian signal


%% Gaussian signal 

D = 20000;
I = linspace(-1,1,D);
k = 3;
sigma = 0.05;
seeds = [];

for l = 1:5
    seed = randi(1000);
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

    
    figure;
    plot(I,pulse);

    hold on 
    
    for i = 1:k
        plot([mu(i), mu(i)], [0,pulse(find(I>mu(i),1))], 'r' );
        text(mu(i),-1, sprintf('\\theta_{%d}',i), 'FontSize', 14);
        hold on 
    end
    ax = gca;
    ax.XTick = [-1 1];
    title(seed)
    %title('A point of the 4 dimensional super-imposed gaussian-pulse manifold')
end