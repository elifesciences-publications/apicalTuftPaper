function [] = exponentialModel(expModel,minMax)
%EXPONENTIALMODEL Summary of this function goes here
%   Detailed explanation goes here
modelfun = @(b,x)(b(1)+b(2)*exp(b(3)*x));
distRange=linspace(minMax(1),minMax(2),500);
modelRatio = modelfun(expModel.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');
end

