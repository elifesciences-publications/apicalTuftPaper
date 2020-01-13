function [ scatterHandle ] = scatter3( array,color,theSize)
%SCATTER scatter plotting utility for double arrays in 3D
    % Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('color','var') || isempty(color)
    color=[1,0,0];
end
if ~exist('theSize','var') || isempty(theSize)
    theSize=36;
end
%flip array if column
if size(array,1)~=3 && size(array,2)==3
    array=array';
end

scatterHandle=scatter3(array(1,:),array(2,:),array(3,:),theSize,color);
scatterHandle.Marker='x';
end

