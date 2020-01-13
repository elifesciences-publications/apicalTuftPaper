function [] = linePlot3(points,color)
%LINEPLOT3
if ~exist('color','var') || isempty(color)
    color = 'k';
end

plot3(points(:,1),...
        points(:,2), points(:,3),color)
end

