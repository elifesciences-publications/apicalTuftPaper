function [] = plotBorderGrids(skel,rotationMatrix)
%PLOTBORDERGRIDS plot nodes as a scatter plot (in nm scale)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('rotationMatrix','var') || isempty(rotationMatrix)
    rotationMatrix = eye(3);
end
nodes = skel.getNodes([],[],true);
nodes = (rotationMatrix*nodes')';
scatter3(nodes(:,1),nodes(:,2),nodes(:,3));
end

