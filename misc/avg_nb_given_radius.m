% Illustration of the number of average nb per ball given the radius

%initialization
rng(12345)
k = 9;          %intrinsic dimension
D = 100;         % ambiant dimension
n = 1000 ;       % nb of samples
sigma = 0.01;    % var of the noise( recall : var = std ^ 2 and std = 0.1 in the paper)

%generating corrupted data (noisy sphere)
noisy_data = generate_sphere(k,D,n,sigma);

dm = distance_matrix(noisy_data);

radius = 0:0.01:3;
avg = zeros(1,length(radius));
dev = zeros(1,length(radius));
for r = 1:length(radius)
    [a, d] = avg_nb_per_ball(dm,radius(r));
    avg(r) = a;
    dev(r) = d;
end

figure
plot(radius,avg,'black',radius,avg+dev,[':','blue'],radius,avg-dev,[':','blue'])
