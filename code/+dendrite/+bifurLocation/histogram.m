function [] = histogram(dataAggregate,l2color,dlcolor)
% HISTOGRAM  plot histogram of the bifurcation locations relative to pia.
% The second dimension (y) represents the distance to pia.
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

hold on
binsize = 20;
histogram(dataAggregate{1}(:,2),130:binsize:290,'FaceColor',[1,1,1],...
    'FaceAlpha',0,'EdgeColor',l2color,'LineWidth',0.5);
histogram(dataAggregate{2}(:,2),130:binsize:290,'FaceColor',[1,1,1],...
    'FaceAlpha',0,'EdgeColor',dlcolor,'LineWidth',0.5);

hold off
end


