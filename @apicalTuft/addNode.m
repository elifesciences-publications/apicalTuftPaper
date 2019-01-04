function [obj, addedEdges]  = addNode(obj, tree_index, coords, ...
    connect_to_ID, varargin)
% addNodeWithID 
% difference with skeleton.addNode: This function addes the node to another 
% Node with specific ID
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

IDToIdxMap=obj.nodeId2Idx;
connect_to=full(IDToIdxMap(connect_to_ID));
[obj, addedEdges] = addNode@skeleton(obj,tree_index, coords, ...
    connect_to,varargin{:});

end

