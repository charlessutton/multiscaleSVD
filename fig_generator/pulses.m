%% Index

% gaussian pattern of pulse
% stair pattern of pulse
% triangle pattern of pulse
 
%% Single gaussian

D = 200;

I = linspace(-1,1,D);
mu = 0;
sigma = 0.05;
pulse = normpdf(I,mu,sigma);

figure();
plot(I,pulse);
ylim([-1.1,1.1*pulse(find(I>mu,1))])
title('Gaussian pattern of pulse {\sigma} = 0.05')

%% Single stair

D = 200;
I = linspace(-1,1,D);
mu = 0;
sigma = 0.1;

start = mu - 0.5*sigma;
start_idx = find(I>start,1);

ends = mu + 0.5*sigma;
ends_idx = find(I>ends,1);

stair_pulse = zeros(1,D);
stair_pulse(1,start_idx:ends_idx) = 1.0/sigma;

figure;
plot(I, stair_pulse);
ylim([0, 0.05 + 1.1/sigma])
title('Stair pattern of pulse  {\sigma} = 0.1')

%% Single triangle

D = 200;

I = linspace(-1,1,D);

mu = 0;
sigma = 0.2;

start = mu - 0.5*sigma;
start_idx = find(I>start,1);

ends = mu + 0.5*sigma;
ends_idx = find(I>ends,1);

middle_idx = find(I>mu,1);

triangle_pulse = zeros(1,D);

triangle_pulse(1,start_idx:middle_idx) = (4/sigma^2)*(I(start_idx:middle_idx) - I(start_idx));
triangle_pulse(1,middle_idx:ends_idx) = (-4/sigma^2)*(I(middle_idx:ends_idx) - I(ends_idx));

figure;

plot(I, triangle_pulse);
ylim([0,1.1*triangle_pulse(middle_idx)])
title('Triangle pattern of pulse {\sigma} = 0.2')

 

