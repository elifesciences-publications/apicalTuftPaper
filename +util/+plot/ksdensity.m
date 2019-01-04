function [] = ksdensity(data,color,bandwidth,bounds)
%KSDENSITY Plot the ksdensity
if ~exist('bounds','var') || isempty(bounds)
    bounds=[min(data(:)),max(data(:))];
end

range=diff(bounds);
[f,xi]=ksdensity(data,bounds(1):range/100:bounds(2),'Support',...
    [bounds(1)-1e-5 bounds(2)+1e-5],'BoundaryCorrection','reflection',...
    'Bandwidth',bandwidth);
plot(xi,f,'Color', color);
% Make sure area under the probability density estimate is =1
assert(1-trapz(xi,f)<1e-3)
end

