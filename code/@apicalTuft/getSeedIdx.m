function [seedComments] = getSeedIdx(obj,treeIndices)
% Get the synapse Idx of the tree
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
obj.checkSeedUniqueness(treeIndices);
seedComments = obj.getNodesWithComment(obj.seed,treeIndices,'partial');
end

