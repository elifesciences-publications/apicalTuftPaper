function [ dist2soma ] = getDist2Soma( skel,treeIndices,idx2keep )
%GETDIST2SOMA Summary of this function goes here
%   Detailed explanation goes here
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end

dist2soma=cell(max(treeIndices),1);
for tr=treeIndices(:)'
    allPaths=skel.getShortestPaths(tr);
    somaIdx=skel.getNodesWithComment('soma',tr,'partial');
    assert(length(somaIdx)==1)
    dist2soma{tr}=allPaths(idx2keep{tr},somaIdx)./1000;
end

end

