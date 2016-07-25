function [subdata] = extract_subdata(point,data,r)
%extract the point in the data set that are in B(point,r)
% return the subdataset w
[n, D] = size(data);
subdata = [];
for i = 1:n 
    if norm(data(i,:)-point)<r 
        subdata = [subdata; data(i,:)];
    end
end
end