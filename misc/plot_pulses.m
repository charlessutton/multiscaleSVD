%% gap peak

%compute multiscale svd before

diff_matrix = diff(Eeigenval,1);
somme =  sum(diff_matrix,2);
normalized = abs(somme)/sum(abs(somme)) ;

% we detect the first "gap peak" by tresholding
% it estimates the intrinsic dimension 
threshold = 0.1;
k = find(normalized > threshold , 1);

figure
plot(1:50,normalized(1:50))
hold on
plot([1 50],[0.1 0.1], '--')
hold on
plot([k k], [0 normalized(k)], ':r')
hold on
legend('normalized cumulative gap','threshold', 'true dim')
xlabel('curve No') % x-axis label
title('Automatic estimation by thresholding')
%% generate concatenated pulses
data = generate_concat_pulse_1D(5,1,3000, 0.02, 0);
figure
plot(linspace(0,1,3000),data(1,:))
ylim([0, 30])
title('concatenated pulse (k = 5)')

%% generate 1D stair pulse
data = generate_stair_pulse_1D(1,1000,0.02,0.01);
figure
plot(linspace(0,1,1000),data(1,:))
ylim([0, 1.5])
title('stair pulse with noise')
%% generate 1D gaussian pulse
data = generate_pulse_1D(1,1000,0.01,0.5);
figure
plot(linspace(0,1,1000),data(1,:))
ylim([0 50])
title('gaussian pulse with noise')