function [bifurcationComments] = getBifurcationIdx(obj,treeIndices)
%GETBIFURCATIONIDX
% Get the Idx of the bifurcation
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
bifurcationComments=obj.getNodesWithComment(obj.bifurcation,...
    treeIndices,'partial');
% Make sure it is a cell
if ~iscell(bifurcationComments)
    bifurcationComments={bifurcationComments};
end
% check bifurcation uniqueness
assert (all(cellfun(@length,bifurcationComments) == 1),...
        'bifurcation comment is not unique');
end

