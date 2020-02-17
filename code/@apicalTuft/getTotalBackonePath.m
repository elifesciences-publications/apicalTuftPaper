function [totalPathLengthInMicron] = getTotalBackonePath(obj,treeIndices)
% getTotalBackonePath Get the total pathlenth of the backbone annotations 
% of all tree
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end

totalPathLengthInMicron=...
    sum(obj.getBackBonePathLength.pathLengthInMicron);

end

