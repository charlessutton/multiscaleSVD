function [ratio] = LR(sv,p,K)
%this functions outputs the likelihood ratio described in bruckstein 1985
%'resolution of overlapping echoes'
%inputs should be singular values given in decreasing order
sv = fliplr(sv);
ratio = (prod(sv(1:p)) ^ (1/p) /  (sum(sv(1:p))/p))^(p*K);
end