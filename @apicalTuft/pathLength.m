function [pL] = pathLength(obj,treeIndices)
%PATHLENGTH Crates a table of pathlength of trees in Micron. 
% For more details see skeleton.pathLength
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if obj.connectedComp.emptyTracing
    pL=table();
    return
end
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(obj.nodes);
end
treeIdx=obj.getTreeIdentifier(treeIndices);
pathLength=pathLength@skeleton(obj,treeIndices,obj.scale/1000);
pL=table(treeIdx,pathLength,'VariableNames',...
    {'treeIdx','pathLengthInMicron'});

end

