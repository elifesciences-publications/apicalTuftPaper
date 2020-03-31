function [] = plotBeforeCorrection(beforeCorrection,corrected,...
    xlocation)
% plotBeforeCorrection: Plots the scatter plots of the density/ratios
% before the correction by the synapse misclassification rate (See Fig.
% 2a-c)

% Author: Ali Karimi<ali.karimi@brain.mpg.de>
% Setup: color and marker size
mkrSize = 15;
theColor = util.plot.getColors().l2color;
hold on
% Scatter plot for the values before correction
scatter(xlocation, beforeCorrection, mkrSize, theColor,'x')
% Lines to connect to the corrected values
for i = 1:length(xlocation)
    Y = [beforeCorrection(i),corrected(i)];
    X = repmat(xlocation(i),1,2);
    plot(X,Y,'Color',theColor);
end
end

