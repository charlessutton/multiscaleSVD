% Tanslation matrices

% fist section shows unitary property of such translation matric T
% second section shows application of it

%% They are Unitary matrices

D = 15;
T  = diag(ones(1,D));

teta = 8;
T_teta = zeros(D,D);

for i = 1:D 
    T_teta(:,i) =  T(:,1+mod(i-teta-1,D));
end

isequal(T_teta * T_teta',eye(D)) %unitary matrix T

%% Translation effect

D = 100;
teta = -25; 
T  = diag(ones(1,D));
T_teta = zeros(size(T));
for i = 1:D T_teta(:,i) =  T(:,1+mod(i-teta-1,D)); end
I = linspace(0,1,D);
signal = normpdf(I,0.5,0.01);
signal_translated = T_teta * signal';

figure;
plot(I,signal,I,signal_translated);
legend('signal','translated');