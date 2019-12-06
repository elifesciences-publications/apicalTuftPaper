function [] = genericModel(model,minMax,thisColor)
%GENERICMODEL 
% Note: model should accept vector

if ~exist('thisColor','var') || isempty(thisColor)
    thisColor = 'k';
end
distRange=linspace(minMax(1),minMax(2),500);
modelRatio = model(distRange);
plot(distRange,modelRatio,thisColor);
end

