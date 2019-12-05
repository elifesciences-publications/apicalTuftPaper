function [] = genericModel(model,minMax)
%GENERICMODEL 
% Note: model should accept vector
distRange=linspace(minMax(1),minMax(2),500);
modelRatio = model(distRange);
plot(distRange,modelRatio,'k');
end

