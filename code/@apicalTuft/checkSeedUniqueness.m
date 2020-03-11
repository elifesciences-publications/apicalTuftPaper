function [] = checkSeedUniqueness(obj,treeIndices)
% checks that all treeIndices have 1 and only 1 seed synapse
% Useful for axonal tracings
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end


if ~isempty(obj.seed)
    seedComments = obj.getNodesWithComment(obj.seed,treeIndices,'partial');
    if ~iscell(seedComments)
        seedComments = {seedComments};
    end
    assert (all(cellfun(@length,seedComments) == 1),...
        'seed comment is not unique');
end
end

