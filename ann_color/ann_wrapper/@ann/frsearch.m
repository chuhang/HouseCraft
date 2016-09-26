function [idx dst inr] = frsearch(ann, query, r, k, epsl, asm)
% 
% kNN FR search
%   Usage:
%     [idx dst inr] = frsearch(ann, query, rad, k, eps, asm)
%
% Inputs:
%   ann - ann class object
%   query - (d)x(N) query points
%   k - number of nearest nieghbors (if points in ann < k than less than k
%                                    points are returned)
%   epsl - epsilon search precision 
%   asm - allow self match flag, if false points with dst = 0 are ignored 
%         (defualt is true)
%
if nargin == 5
    asm = true;
end

if ~asm
    k = k+1;
end

if ~isa(query, ann.ccls)
    query = ann.cfun(query);
end

[idx dst inr] = annmex(ann.modes.FRSEARCH, ann.kd_ptr, query, k, epsl, r);
% for points that has less than k ANN within the proper rad
% idx equals -1 and dst is a very large const for the entries larger than
% inr

% remove self matches
if ~asm
    gsm = dst(1,:)==0;
    dst(1:end-1,gsm) = dst(2:end,gsm);
    idx(1:end-1,gsm) = idx(2:end,gsm);
    dst(end,:) = [];
    idx(end,:) = [];
    inr(gsm) = inr(gsm)-1;
end

not_found = idx == -1;
idx(not_found) = -2; % cannot assign NaN to int32 variable
dst(not_found) = inf;

idx = idx + 1; % fix zero indexing of ann
