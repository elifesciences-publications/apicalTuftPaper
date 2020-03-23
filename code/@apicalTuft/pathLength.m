function [pL] = pathLength(obj,treeIndices)
% PATHLENGTH Wrapper function for skeleton.pathLength from /auxiliaryMethods
% It generates a table of path length of each annotation tree (micrometers). 
% For more details see skeleton.pathLength

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if obj.connectedComp.emptyTracing
    pL = table();
    return
end
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(obj.nodes);
end
treeIdx = obj.getTreeIdentifier(treeIndices);
scale_inMicrons = obj.scale/1000;
pathL = pathLength@skeleton(obj,treeIndices,scale_inMicrons);
pL = table(treeIdx,pathL,'VariableNames',...
    {'treeIndex','pathLengthInMicron'});

end

