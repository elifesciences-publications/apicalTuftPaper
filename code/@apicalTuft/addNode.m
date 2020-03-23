function [obj, addedEdges]  = addNode(obj, tree_index, coords, ...
    connect_to_ID, varargin)
% addNode wrapper function for skeleton.addNode
% difference: This function addes the node to another Node with specific ID

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Get the Index of the node from the ID given
IDToIdxMap = obj.nodeId2Idx;
connect_to = full(IDToIdxMap(connect_to_ID));
% Pass to skeleton.addNode
[obj, addedEdges] = addNode@skeleton(obj,tree_index, coords, ...
    connect_to,varargin{:});
end

