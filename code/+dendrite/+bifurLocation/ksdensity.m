function [] = ksdensity(dataAggregate,l2color,dlcolor)
%KSDENSITY plot the probability estimate function for the aggregate data from
% layer 2 and deep layers

% Author: Ali Karimi<ali.karimi@brain.mpg.de>

%   Bandwidth = 25 um based on the estimation of l2 case
hold on
util.plot.ksdensity(dataAggregate{1}(:,2),l2color,25,[130 290]);
util.plot.ksdensity(dataAggregate{2}(:,2),dlcolor,25,[130 290]);
end

