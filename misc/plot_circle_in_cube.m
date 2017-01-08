% Script to draw the figure in the exam question

%first we generate de data with intrinsic dimensionality = 1
n = 100000; % sample size
teta = 2*pi*rand(n,1); %our 1D parameter
x = cos(teta);
y = sin(teta);
z = zeros(n,1);
data = [x,y,z];

% 2D circle in a 3D ambiant space
figure
scatter3(data(:,1),data(:,2),data(:,3))
title('$2$-dimensional sphere in $R^{3}$', 'Interpreter', 'latex')
xlabel('x')
ylabel('y')
zlabel('z')
