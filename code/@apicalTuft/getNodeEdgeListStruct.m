function [agglo] = getNodeEdgeListStruct(skel,treeIndex)
% getNodeEdgeListStruct get an structure with node and edge fields from a
% tree of a tracing. Similar to superAgglos
%     treeIndex(default: treeIndex = 1): The id of tree to be output as an
%     agglo structure
%     agglo: The structure containing node and edge fields
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndex','var') || isempty(treeIndex)
    assert(skel.numTrees == 1);
    treeIndex = 1;
end
agglo = struct();
agglo.nodes = skel.nodes{treeIndex};
agglo.edges = skel.edges{treeIndex};

end

