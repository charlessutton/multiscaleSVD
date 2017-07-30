function [data] = generate_neighs(options)
% this function generates a k-pulse and then its neighbours
% it aims to serve local linearity verifications
% NOT circular for the moment 

if ~isfield(options,'width') error('please add field width to options'); end
if ~isfield(options,'epsilon') error('please add field espilon to options'); end
if ~isfield(options,'D') error('please add field D to options'); end
if ~isfield(options,'neigh') error('please add field "neigh" to options'); end
if ~isfield(options,'k') error('please add field k to options'); end
if ~isfield(options,'mu') 
    options.mu = rand(1,options.k); 
else
    assert(length(options.mu)==options.k, 'mu is not of size k');
end % this field may or may not be set manually

data = zeros(1 + options.neigh, options.D);
I = linspace(-1,1,options.D);

switch options.type
    case 'gaussian'
        %original pulse
        for i = 1:options.k
            data(1,:) = data(1,:) + normpdf(I, options.mu(i), options.width); 
        end
        
        %neighbour pulses simulation
        for j = 2 : (options.neigh + 1)
            mu_neigh = options.mu + options.epsilon * rand(1,options.k);
            for i = 1:options.k
                data(j,:) = data(j,:) + normpdf(I, mu_neigh(i), options.width); %neighbour pulse
                data(j,:) = data(j,:) + options.noise_level*randn(1,options.D);
            end
        end
        
    case 'triangle'
        % original pulse
        for i = 1:options.k
            middle_point = options.mu(i);
            middle_point_idx =  find(I > middle_point,1); 
            start_point_idx = find(I > middle_point - options.width,1);
            end_point_idx = find(I>middle_point + options.width,1)-1;
            data(1,start_point_idx:middle_point_idx) = data(1,start_point_idx:middle_point_idx) +  (1/options.width^2)*(I(start_point_idx:middle_point_idx) - I(start_point_idx));
            data(1,middle_point_idx+1:end_point_idx) =  data(1,middle_point_idx+1:end_point_idx)  - (1/options.width^2)*(I(middle_point_idx+1:end_point_idx) - I(end_point_idx));
        end
        
        for j = 2 : (options.neigh + 1)
            mu_neigh = options.mu + options.epsilon * rand(1,options.k);
            for i = 1:options.k
                middle_point = mu_neigh(i);
                middle_point_idx =  find(I > middle_point,1); 
                start_point_idx = find(I > middle_point - options.width,1);
                end_point_idx = find(I>middle_point + options.width,1)-1;
                data(j,start_point_idx:middle_point_idx) = data(j,start_point_idx:middle_point_idx) +  (1/options.width^2)*(I(start_point_idx:middle_point_idx) - I(start_point_idx));
                data(j,middle_point_idx+1:end_point_idx) =  data(j,middle_point_idx+1:end_point_idx)  - (1/options.width^2)*(I(middle_point_idx+1:end_point_idx) - I(end_point_idx));
                data(j,:) = data(j,:) + normpdf(I, mu_neigh(i), options.width); %neighbour pulse
            end
        end
        
    case 'stair'
        % orignal pulse 
        for i = 1:options.k
            start_point = options.mu(i) ; 
            start_point_idx = find(I > start_point,1);
            end_point_idx = find(I>start_point+options.width,1);
            data(1,start_point_idx:end_point_idx) = data(1,start_point_idx:end_point_idx) + 1/options.width;    
        end
        
        for j = 2 : (options.neigh + 1)
            mu_neigh = options.mu + options.epsilon * rand(1,options.k);
            for i = 1:options.k
                start_point = mu_neigh(i) ;
                start_point_idx = find(I > start_point,1);
                end_point_idx = find(I>start_point+options.width,1);
                data(j,start_point_idx:end_point_idx) = data(j,start_point_idx:end_point_idx) + 1/options.width;
            end
        end
    otherwise
        msg = 'this type is not available for the moment';
        error(msg)
end

end