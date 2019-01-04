function [IdxOfSkelSubsetNodesInSkel] = ...
    nodeIdxToIdxAnotherSkel(skel,skelSubset,treeIndices)
% nodeIdxToIdxAnotherSkel This function creates a map from node indices of
% skelSubset to nodeIndices of skel, the node indices of skelSubset should 
% be a subset nodes in skel. Example would be skelSubset is backbone of skel.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices', 'var') || isempty(treeIndices)
    assert(skel.numTrees>=skelSubset.numTrees)
    treeIndices = 1:skel.numTrees();
end

Id2IdxSkel=skel.nodeId2Idx(treeIndices);
Idx2IdSkel2=skelSubset.nodeIdx2Id(treeIndices);

IdxOfSkelSubsetNodesInSkel=cell(size(treeIndices));
for i=1:length(treeIndices)
    tr=treeIndices(i);
    IdxOfSkelSubsetNodesInSkel{i}=full(Id2IdxSkel(Idx2IdSkel2{i}));
    assert(size(skelSubset.nodes{tr},1)==...
        length(IdxOfSkelSubsetNodesInSkel{i}),...
    'Checking the number of skelSubset nodes are conserved along the')
end
end

