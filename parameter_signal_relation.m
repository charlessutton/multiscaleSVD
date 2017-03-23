% Helping script to find control bounds of the distance

sigma = 0.2;

I = linspace(-5,5,500);
initial_gaussian = normpdf(I, 0, sigma);
figure;
plot(I,initial_gaussian);

i = 0;
thetas = 0:0.01:1;
for theta = thetas
    i=i+1;
    translated_gaussian =  normpdf(I, theta, sigma);
    distance(i) = norm(translated_gaussian-initial_gaussian);
end

figure;
scatter(thetas,distance,'filled');