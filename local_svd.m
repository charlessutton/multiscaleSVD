function [Eeigval] = local_svd(data,r)
% this perform the local svd on the data restricted
% then we take the mean of the eigen values
[n,D] = size(data);
max_rank = min([n,D]);

Eeigval = zeros(max_rank,1); %column vector
for i = 1:n 
    subdata = extract_subdata(data(i,:),data,r);
    subdata = bsxfun(@minus,subdata,mean(subdata,1));
    local_eigval = svd(subdata);
    Eeigval(1:size(local_eigval,1),1) = Eeigval(1:size(local_eigval,1),1) + local_eigval; %column vector %sum of eigvals
end
Eeigval = Eeigval/n; %we take the mean above the number of samples
end