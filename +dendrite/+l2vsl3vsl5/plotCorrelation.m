function [fh,ax,exp] = plotCorrelation(distance2soma,...
    Measure)
% PLOTCORRELATION 


crossSize=72;
colors=util.plot.getColors;
dist2somaColors={colors.l2color,colors.l3color,colors.l5color};
fh=figure;ax=gca;
hold on
for dataset=1:3
curDist=distance2soma{dataset};
curRatio=Measure{dataset};
scatter(curDist,curRatio,crossSize,dist2somaColors{dataset},'x');
end
distArray=cat(1,distance2soma{:});
ratioArray=cat(1,Measure{:});
% Fit one and two-term exponentials to the data
[exp.one.f,exp.one.gof]=fit(distArray,ratioArray,'exp1');
[exp.two.f,exp.two.gof]=fit(distArray,ratioArray,'exp2');
% Fit single exponential with offset
[exp.oneWithOff]=...
    dendrite.l2vsl3vsl5.exponentialFitWithOffset...
    (distArray,ratioArray);

end

