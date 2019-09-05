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
if ~exist('xlocationRaw','var') || isempty(xlocationRaw)
    xlocationRaw=1:length(array);
end
% Make sure that xlocationRaw is a double array and the xLocation is a cell
% array
if ~iscell(xlocationRaw)
    xLocation=num2cell(xlocationRaw);
else
    xLocation=xlocationRaw;
    xlocationRaw=cell2mat(xlocationRaw);
end
xLocation=xLocation(:);
array=array(:);

% set defaults
optIn.ylim=max(cellfun(@max,array(:)))+0.1;
optIn.boxWidth=1;
optIn.xlim=[min(cell2mat(xLocation))-optIn.boxWidth,...
    max(cell2mat(xLocation))+optIn.boxWidth];
optIn.color=[1 0 0];
optIn.tickSize=10;
optIn.boxplot=true;
optIn.marker='x';
optIn=Util.modifyStruct(optIn,varargin{:});
optIn.xlim=[min(cell2mat(xLocation))-optIn.boxWidth,...
    max(cell2mat(xLocation))+optIn.boxWidth];
% repeat if you have a single RGB
if ~iscell(optIn.color)
    optIn.color=repmat({optIn.color},size(array(:)));
end

% Different group with different color but plotted on the same location 
% (Used) first time to add L2MN cells to L2 cells
[~,ind]=unique(xlocationRaw);
setdiff(1:length(xlocationRaw),ind)
dupIdx=setdiff(1:length(xlocationRaw),ind);
if ~isempty(dupIdx)
    for i=1:length(dupIdx)
        curDup=dupIdx(i);
        curXLoc=xLocation{curDup};
        lengthOriginal=length(array{curXLoc});
        lengthDup=length(array{curDup});
        % Concatenate the array to the original location
        array{curXLoc}=[array{curXLoc};array{curDup}];
        optIn.color{curXLoc}=[repmat(optIn.color{curXLoc},lengthOriginal,1);...
            repmat(optIn.color{curDup},lengthDup,1)];
    end
    array(dupIdx)=[];
    optIn.color(dupIdx)=[];
    xLocation(dupIdx)=[];
end
%% Add noisy x for scatter plot
arrayWithNoisyX=cellfun(@(array,position)util.plot.addHorizontalNoise(array,position,optIn.boxWidth-0.1),...
    array(:),xLocation,'UniformOutput',false);

%% Creating the figure
hold on;

% Overlay scatter plot
cellfun(@(data,color)util.plot.scatter...
    (data,color,optIn.tickSize,optIn.marker),arrayWithNoisyX,...
    optIn.color(:),'UniformOutput',false);
% Boxplot
if optIn.boxplot
cellfun(@(x,y)boxplot(x,'Positions',y,'Colors','k','Widths',optIn.boxWidth,'Symbol',''),...
    array(:),xLocation)
end
xlim(optIn.xlim);
ylim([0,optIn.ylim]);
xticks(sort(cell2mat(xLocation)));
xticklabels([])
hold off
end

