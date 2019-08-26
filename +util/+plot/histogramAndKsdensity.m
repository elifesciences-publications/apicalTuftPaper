function histogramAndKsdensity(data,color,ylimitsKS)
% Function used for plotting the histogram and KernelDensity for figure 1H

if ~exist('ylimitsKS','var') || isempty(ylimitsKS)
    ylimitsKS=[0,15];
end
hold on
ax=gca;
yyaxis(ax,'left');
ax.YColor=[0,0,0];
histogram(data,...
    0:0.1:1,'FaceColor',[1,1,1],'FaceAlpha',0,'EdgeColor',color);
yyaxis(ax,'right')
ax.YColor=[0,0,0,0.5];
% Add transparency to color
% Value of bandwidth (0.0573) was from deep L1 axons. To make the densities
% comparable I used it for calculating both layer 2 and deep densities
util.plot.ksdensity(data,color(:)',0.0573,[0 1]);
ylim(ylimitsKS)
hold off
end
