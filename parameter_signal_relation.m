% Helping script to find control bounds of the distance
clc ;
clear all;

b = 10;
a = -10;

sigma = 1;

I = linspace(a,b,500);
initial_gaussian = normpdf(I, 0, sigma);
figure;
plot(I,initial_gaussian);

i = 0;
thetas = 0:0.25:5;
for theta = thetas
    i=i+1;
    translated_gaussian =  normpdf(I, theta, sigma);
    distance(i) = norm(translated_gaussian-initial_gaussian);
    formula(i) = (normcdf(b*sqrt(2))-normcdf(a*sqrt(2)))/sqrt(2) ...
    -sqrt(2)*exp(-0.25*theta*theta)*(normcdf((b-0.5*theta)*sqrt(2))-normcdf((a-0.5*theta)*sqrt(2)))...
    + (normcdf((b-theta)*sqrt(2))-normcdf((a-theta)*sqrt(2)))/sqrt(2);
end

figure;
plot(thetas,distance.*distance,thetas,formula);
legend('norm','formula');

formula ./ (distance.*distance) % multiplicative constant 