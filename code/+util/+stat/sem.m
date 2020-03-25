function [semValue] = sem(array,weight,dim)
%SEM measure the standard error of the mean for array along a specific
%dimension(dim)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('dim','var') || isempty(dim)
    dim = 1;
end
if ~exist('weight','var') || isempty(weight)
    weight = ones(size(array,1),1);
end
% ignore nan values in the matrix
if any(isnan(array(:)))
    stdfun = @nanstd;
else
    stdfun = @std;
end

%taken from: http://www.analyticalgroup.com/download/WEIGHTED_MEAN.pdf
% tested using the sample given there, x = [5,5,4,4,3,4,3,2,2,1],
% w = [1.23,2.12,1.23,0.32,1.53,0.59,0.94,0.94,0.84,0.73]
% b = number of samples if all weights = 1
b = (sum(weight).^2)./sum(weight.^2);
if min(size(array)) == 1
    stdValue = stdfun(array);
else
    stdValue = stdfun(array,0,dim);
end

semValue = stdValue./sqrt(b);
end

