function [] = genericModel(model,minMax,thisColor)
% GENERICMODEL plot a model 
% Note: model should accept vector
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('thisColor','var') || isempty(thisColor)
    thisColor = 'k';
end
distRange = linspace(minMax(1),minMax(2),500);
modelRatio = model(distRange);
plot(distRange,modelRatio,thisColor);
end

