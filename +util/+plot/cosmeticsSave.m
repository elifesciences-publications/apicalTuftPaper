function [] = cosmeticsSave(fh,ax,x_width,y_width,outputFolder,fileName,...
    xtickMinor,ytickMinor,removeDashedLinesForBoxplot)
% cosmeticsSave This function applies the setFigureHandle and setAxisHandle
% functions to the figure and axis chosen
if ~exist('ytickMinor','var') || isempty(ytickMinor)
    ytickMinor = 'off';
end
if ~exist('xtickMinor','var') || isempty(xtickMinor)
    xtickMinor = 'off';
end
if ~exist('removeDashedLinesForBoxplot','var') || ...
        isempty(removeDashedLinesForBoxplot)
    removeDashedLinesForBoxplot = true;
end
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
fh=util.plot.setFigureHandle(fh,'height',y_width,'width',x_width);
if removeDashedLinesForBoxplot
    set(findobj(fh,'LineStyle','--'),'LineStyle','-');
end
ax=util.plot.setAxisHandle(ax,[],xtickMinor,ytickMinor);
saveas(gca,fullfile(outputFolder,...
    util.addDateToFileName(fileName)));
[~,hostname]=system('hostname');
if strcmp(hostname(1:6),'ali-pc')
    system('./synPlots.sht');
    disp('Copied plots to fileServer')
end
end

