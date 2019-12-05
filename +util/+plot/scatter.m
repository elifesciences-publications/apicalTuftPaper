function [ scatterHandle ] = scatter( array,color,theSize,marker)
%SCATTER scatter plotting utility for double arrays
    % Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('color','var') || isempty(color)
    color=[1,0,0];
end
if ~exist('theSize','var') || isempty(theSize)
    theSize=10;
end
if ~exist('marker','var') || isempty(marker)
    marker='x';
end
% flip array if column
if size(array,1)==2 && size(array,2)==2
    warning('Array flipping might malfunction here')
end
if size(array,1)~=2 && size(array,2)==2
    array=array';
end
% First row should be X location and the second row the actual values
scatterHandle=scatter(array(1,:),array(2,:),theSize,color);
scatterHandle.Marker=marker;
scatterHandle.MarkerFaceColor='flat';
scatterHandle.LineWidth=1;
end

