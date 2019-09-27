function [] = cosmeticsSave(fh,ax,x_width,y_width,outputFolder,fileName,...
    xtickMinor,ytickMinor,removeDashedLinesForBoxplot)
% cosmeticsSave This function applies the setFigureHandle and setAxisHandle
% functions to the figure and axis chosen
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Defaults
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
screenSizeCorrection=1.3333;
fh=util.plot.setFigureHandle(fh,'height',y_width*(2/screenSizeCorrection),...
    'width',x_width*(2/screenSizeCorrection));
if removeDashedLinesForBoxplot
    set(findobj(fh,'LineStyle','--'),'LineStyle','-');
end
if isvalid(ax)
    util.plot.setAxisHandle(ax,[],xtickMinor,ytickMinor);
end
% If output folder does not exist assume the filename is the fullname of
% the file
if ~exist('outputFolder','var') || isempty(outputFolder)
    print(fh,fileName,'-dsvg');
else
util.mkdir(outputFolder);
print(fh,fullfile(outputFolder,...
    fileName),'-dsvg');
end
[~,hostname]=system('hostname');
if strcmp(hostname(1:6),'ali-pc')
    system('./synPlots.sht');
    disp('Copied plots to fileServer')
end
end

