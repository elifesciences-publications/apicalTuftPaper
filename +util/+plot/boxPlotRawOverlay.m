function boxPlotRawOverlay(array,xlocationRaw,varargin)
% boxPlotRawOverlay creates an overlay of raw data  over a boxplot for a cell
% array
% INPUT:
%       array:
%           cell array with each cell containing a 1xN double array of
%           the measurement
%       xlocationRaw:
%           the position of box/scatter plot overlay
%       varargin:
%           boxWidth :the width of each box plot equal to the noise level
%               for the raw overlay
%           color: the color of scatter points. Note: theboxplot is always
%               black, Note: it could be 3 digit RGB or a cell array of RGBs
%           ylim: the y limit
%           tickSize: the size of the scatter tick marks
% The locations and data should be of the same size and shape
if ~iscell(xlocationRaw)
    xLocation=num2cell(xlocationRaw);
else
    xLocation=xlocationRaw;
end
xLocation=xLocation(:);
array=array(:);

% set defaults
optIn.ylim=max(cellfun(@max,array(:)))+0.1;
optIn.boxWidth=1;
optIn.xlim=[min(cell2mat(xLocation))-optIn.boxWidth,...
    max(cell2mat(xLocation))+optIn.boxWidth];
optIn.color=[1 0 0];
optIn.tickSize=36;
optIn=Util.modifyStruct(optIn,varargin{:});
% repeat if you have a single RGB
if ~iscell(optIn.color)
    optIn.color=repmat({optIn.color},size(array(:)));
end
%% Add noisy x for scatter plot
arrayWithNoisyX=cellfun(@(array,position)util.plot.addHorizontalNoise(array,position,optIn.boxWidth-0.1),...
    array(:),xLocation,'UniformOutput',false);

%% Creating the figure
hold on;

% Overlay scatter plot
cellfun(@(data,color)util.plot.scatter(data,color,optIn.tickSize),arrayWithNoisyX,...
    optIn.color(:),'UniformOutput',false);
% Boxplot
cellfun(@(x,y)boxplot(x,'Positions',y,'Colors','k','Widths',optIn.boxWidth,'Symbol',''),...
    array(:),xLocation)

xlim(optIn.xlim);
ylim([0,optIn.ylim]);
xticks(sort(cell2mat(xLocation)));
xticklabels([])
hold off
end

