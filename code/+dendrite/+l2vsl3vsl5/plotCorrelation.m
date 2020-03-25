function [fh,ax,exp] = plotCorrelation(distance2soma,...
    Measure,beta0, colors)
% PLOTCORRELATION
if ~exist('beta0','var') || isempty (beta0)
    beta0 = [];
end
if ~exist('colors','var') || isempty (colors)
    colors = util.plot.getColors().l2vsl3vsl5;
end
crossSize = 10;
fh = figure;ax = gca;
hold on
for dataset = 1:length(distance2soma)
    curDist = distance2soma{dataset};
    curRatio = Measure{dataset};
    scatter(curDist,curRatio,crossSize,colors{dataset},'x');
end
distArray = cat(1,distance2soma{:});
ratioArray = cat(1,Measure{:});
% Fit one and two-term exponentials to the data
[exp.one.f,exp.one.gof] = fit(distArray,ratioArray,'exp1');
[exp.two.f,exp.two.gof] = fit(distArray,ratioArray,'exp2');
% Fit single exponential with offset
[exp.oneWithOff] = ...
    dendrite.l2vsl3vsl5.exponentialFitWithOffset...
    (distArray,ratioArray,beta0);

end

