s = 0;
for i = 1:n
    s = s + norm(noisy_sphere(i,:));
end
s/n

s = 0;
for i = 1:n
    s = s + norm(sphere(i,:));
end
s/n

s = 0;
for i = 1:n
    s = s + norm(noise(i,:));
end
s/n