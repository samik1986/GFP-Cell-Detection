%This function clusters and merges nearby cell-centers

%{
%-----------------------------------------------------------------------
INPUTS

'X': cell centers that need to be clustered and merged 
    (size:c x 2 where each row gives xy coordinates of a cell center)
'mindist': minimum distance between the two points below which they will 
            be merged (scalar value)
%------------------------------------------------------------------------
OUTPUTS

'g': cell centers obtained after clustering merging (size: d x 2)
%------------------------------------------------------------------------
%}

function [ g ] = cluster(X,mindist)
 nX = sum(X.^2,2);
 d = bsxfun(@plus,nX,nX')-2*X*X';
 [p,~,r] = dmperm(d<mindist^2);
 nvoxels = diff(r);
 for n=find(nvoxels>1) 
   idx = p(r(n):r(n+1)-1);
   X(idx,:) = repmat(mean(X(idx,:),1),numel(idx),1); 
   X(idx(2:end),:) = nan;
 end
 X(any(isnan(X),2),:) = [];
 g=X;
end
