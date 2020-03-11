function [totalPathLengthInMicron] = getTotalPathLength(obj,treeIndices)
% getTotalPathLength Get the total pathlenth of an annotation
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
totalPathLengthInMicron = ...
    sum(obj.pathLength.pathLengthInMicron);

end

