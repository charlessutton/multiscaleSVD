function [ratio] = LR_wax(sv,k,N)
%this functions outputs the likelihood ratio described in wax 1985
%'detection of signals by information theoretic criteria'
% p denotes the number of eigen values involved in the calculus (p-k in the
% formula 14)
p = length(sv);
ratio = (geomean(sv(k+1:p)) /  mean(sv(k+1:p)))^((p-k)*N);
end