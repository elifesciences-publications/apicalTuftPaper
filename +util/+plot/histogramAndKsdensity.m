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
util.plot.ksdensity(data,color(:)',0.0573,[0 1]);
ylim(ylimitsKS)
hold off
end
