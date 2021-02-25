%This function creates a gaussian filter with a specific sigma

%{
%-----------------------------------------------------------------------
INPUTS

'sigma': standard deviation
%-----------------------------------------------------------------------
OUTPUTS

'gauss': gaussian filter with standard deviation sigma
%------------------------------------------------------------------------
%}


function [ gauss ] = gaussFun(sigma)
cutoff=ceil(3*sigma);
gauss = fspecial('gaussian',[1,2*cutoff+1],sigma);
end

