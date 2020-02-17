function [] = cosmeticsSave(fh,ax,x_width,y_width,outputFolderLocal,fileName,...
    xtickMinor,ytickMinor,removeDashedLinesForBoxplot)
% cosmeticsSave prepares and saves the figure panel. This is done by
% setting figure and axes properties
% INPUT: fh: The figure handle object
%        ax: axes handle object
%        x_width: width of the image panel(in mm)
%        y_width: height of the image panel (in mm)
%        outputFolderLocal: Local directory to save the panel
%        fileName: The name of the file (including extension). The default
%        extenion is SVG
%        xtickMinor: (default: 'off') Whether to add minor ticks to X-axis
%        ytickMinor: (default: 'off') Whether to add minor ticks to Y-axis
%        removeDashedLinesForBoxplot: (default: True) Remove the dashed
%        lines in boxplot

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

%% Settings
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
% Correct for the screen size issue on Linux OS
% TODO: test see if this is necessary on windows
screenSizeCorrection=1.3333;
% set figure handle properties
fh = util.plot.setFigureHandle(fh,'height',y_width*(2/screenSizeCorrection),...
    'width',x_width*(2/screenSizeCorrection));
% Remove dashed lines
if removeDashedLinesForBoxplot
    set(findobj(fh,'LineStyle','--'),'LineStyle','-');
end
% Only set axis handles when it exists. In conditional probability matrices
% it would be removed
if isvalid(ax)
    util.plot.setAxisHandle(ax,[],xtickMinor,ytickMinor);
end
%% Save
% Get the filetype to be saved
[~,~,ftypeWithDot] = fileparts(fileName);
if ~isempty(ftypeWithDot)
    ftype = strrep(ftypeWithDot,'.','-d');
else
    ftype ='dsvg';
end

% If output folder does not exist assume the filename is the fullname of
% the file
if ~exist('outputFolderLocal','var') || isempty(outputFolderLocal)
    print(fh,fileName,ftype);
else
    util.mkdir(outputFolderLocal);
    print(fh,fullfile(outputFolderLocal,...
        fileName),ftype);
end
% Generate remote file name
remoteStub = util.dir.loadRemote;
if ~isempty(remoteStub)
    splitLocal = strsplit(outputFolderLocal,'Figures');
    remoteDir = fullfile(remoteStub,splitLocal{2});
    util.mkdir(remoteDir,false);
    % Copy files to the fileserver for import into Adobe Illustrator
    success = copyfile(fullfile(outputFolderLocal,fileName),fullfile(remoteDir));
    assert(success,'file not copied to file server');
end
end

