function [allPaths] = getShortestPaths(skel, treeIndices)
% GETSHORTESTPATHS 
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees();
end
allPaths = cell(size(treeIndices));
for i = 1:length(treeIndices)
    tr = treeIndices(i);
    allPaths{i} = getShortestPaths@skeleton(skel,tr);
end
end

