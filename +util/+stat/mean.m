function [meanVal] = mean(inputArray,weight,dim)
%MEAN weighted mean along specified dimension
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('dim','var') || isempty(dim)
    dim=1;
end
if min(size(weight))==1 && all(size(inputArray)==size(weight))
    dim=find(~(size(inputArray)==size(weight)));
end
if ~exist('weight','var') || isempty(weight)
    weight=ones(size(inputArray,1),1);
end

meanVal = sum(weight.*inputArray,dim,'omitnan')./sum(weight,dim,'omitnan');
end

