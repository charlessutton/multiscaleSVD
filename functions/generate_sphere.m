function [data] = generate_sphere(k,D,n,sigma)
%this function generate a k dimensionnal sphere in a D space dimension
% efficiently !
% you can corrupt it by a gaussian noise (0,sigma) if sigma > 0
% n is the size of the sample
data = zeros(D,n);
data(1:k+1,:) = randn(k+1,n); %we generate k dimensionnal samples
norm_col = diag(sqrt(data'*data)); % we compute the norm of each sample (in column)
data = bsxfun(@rdivide,data,norm_col') ; %we project points on the sphere 1
data = data';
%noisy sphere
if sigma>0 
    data = data + sigma*randn(n,D);  % we add noise
end
end