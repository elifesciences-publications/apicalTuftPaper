function [] = plotUncorrected(uncorrected,corrected,...
    xlocation)
% PLOTUNCORRECTED: Plots the uncorrected scatter plots and connects them to
% the corrected values using a line
mkrSize = 10;
theColor = util.plot.getColors().l2color;
hold on
scatter(xlocation, uncorrected, mkrSize, theColor,'x')
for i = 1:length(xlocation)
    Y = [uncorrected(i),corrected(i)];
    X = repmat(xlocation(i),1,2);
    plot(X,Y,'Color',theColor);
end
end

