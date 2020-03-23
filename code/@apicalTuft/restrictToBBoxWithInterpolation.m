function [skel,toKeepNodes] = restrictToBBoxWithInterpolation...
    (skel, bbox, treeIndices,comment2Add)
% Restrict nodes of a Skeleton to a cubic bounding box. All
% nodes outside of this bounding box will be deleted. The edges that are
% deleted by this process at the bbox border are replaced by the
% interpolation of their crossection with bbox

% INPUT bbox: [3x2] integer array containing the first and last
%             voxel of the bounding box in the respective
%             dimension.
%       treeIndices:(Optional) Vector of integer specifying the
%           trees of interest.
%           (Default: all trees).
%       comment2Add: (Optional) comment to add to the edges of the bbox
%       after restriction

% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Note: This helps significantly with the edges. For axonal path in Fig. 3c
% the total path length difference were always under 1 um, whereas normal
% restrict 2 bbox had an error of above 100 um for each dataset.

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(skel.nodes);
end
if ~exist('comment2Add','var') || isempty(comment2Add)
    comment2Add = '';
end
closeGap = false;
% Keep a copy of the original skeleton that does not get deleted for
% mapping from Idx to ID
originalSkeleton = skel;
% The node ID of the nodes kept in the skeleton after restriction for each
% tree in treeIndices
toKeepNodes = cell(size(treeIndices));
for i = 1:length(treeIndices)
    tr = treeIndices(i);
    if ~isempty(skel.nodes{tr})
        trNodes = skel.nodes{tr}(:,1:3);
        % Find nodes that are outside the bbox. The nodes coinciding with
        % the edges are kept
        toDelNodes = any(bsxfun(@gt,trNodes, bbox(:,2)') | ...
            bsxfun(@lt,trNodes, bbox(:,1)'),2);
        % Delete nodes
        skel = skel.deleteNodes(tr, toDelNodes, closeGap);
        skel = interpolateEdges...
            (skel,originalSkeleton,toDelNodes,tr,bbox,comment2Add);
        % Get the ID of the nodes you keep and pass them as output
        idx2IDMap = originalSkeleton.nodeIdx2Id(tr);
        toKeepNodes{i} = idx2IDMap{1}(~toDelNodes);
    end
end

end

function skelInterpolated = interpolateEdges...
    (skel,originalSkeleton,toDelNodes,tr,bbox,flagComment)

% Default: Comment added to new cut edges
if ~exist('flagComment','var') || isempty(flagComment)
    flagComment = '';
end

% Nodes: Convert from logical to indices
toKeepNodes = find(~toDelNodes);
toDelNodes = find(toDelNodes);

% Do not continue if all or none of the nodes are deleted
% Interpolation is unnecessary in these cases
if isempty(toKeepNodes) || isempty(toDelNodes)
    skelInterpolated = skel;
    return
end

% Get a list of nodes involved on the border of the Bbox
edgeList = originalSkeleton.edges{tr};
BorderEdgesIdx = (ismember(edgeList(:,1),toDelNodes) & ...
    ismember(edgeList(:,2),toKeepNodes)) |...
    (ismember(edgeList(:,1),toKeepNodes) & ...
    ismember(edgeList(:,2),toDelNodes));
BorderEdges = originalSkeleton.edges{tr}(BorderEdgesIdx,:);
BorderEdgesCell = ...
    mat2cell(BorderEdges,ones(size(BorderEdges,1),1),2);
nodesOfTheEdges = cellfun(@(x) originalSkeleton.nodes{tr}(x,1:3), ...
    BorderEdgesCell,'UniformOutput',false);

% Find location on the bbox to interpolate the edges
dim2InterpolateAlong = skel.datasetProperties.dimPiaWM;
[ylocation2Interpolate, validInterp] = cellfun(@(nodes)...
    util.crossBboxAndEdges(nodes,bbox,dim2InterpolateAlong), ...
    nodesOfTheEdges,'UniformOutput',false);

% Actual interpolation
interpNodeCoords = cellfun...
    (@ (x,y)util.math.linearInterpolation3(x,y,dim2InterpolateAlong),...
    nodesOfTheEdges,ylocation2Interpolate,'UniformOutput',false);

% Find the row index of the node to connect. This is the node of the edge
% that is not deleted.
nodeIdx2Attach = zeros(size(BorderEdges,1),1);
for i = 1:size(BorderEdges,1)
    % Note: output of the intersect is set to sorted by default
    nodeIdx2Attach(i,1) = intersect(BorderEdges(i,:),toKeepNodes,'stable');
end
% Now get the node ID (from original skeleton) which could be used to get the node Idx in the new
% tree
idx2ID = originalSkeleton.nodeIdx2Id{tr};
nodeID2Attach = idx2ID(nodeIdx2Attach);
% Circular check
[~,toCheckIdx] = originalSkeleton.getNodesWithIDs(nodeID2Attach,tr);
assert(all(toCheckIdx == nodeIdx2Attach), ...
    'Check on nodeIdx to attach to, did not pass')

% This is to check cases where the skeleton is empty, Not that code after
% this conditional is only run if the condition is passed
if ~isempty(validInterp)
    % do nothing
else
    error('the valid interpolation flag should not be empty')
end
% Only keep the information from the interpolated nodes. Nodes that
% exactly coincide with the edge are left as they are.
validInterp = cell2mat(validInterp);
attachID_valid = nodeID2Attach(validInterp);
attachID_alreadyPresent = nodeID2Attach(~validInterp);
interpNodeCoords = interpNodeCoords(validInterp);
attachIdx_valid = nodeIdx2Attach(validInterp);
BorderEdges = BorderEdges(validInterp,:);
% Add the flag comment to the nodes which are already present
% (original, not interpolated edge nodes)
if ~isempty(attachID_alreadyPresent)
    IDToIdxMap = skel.nodeId2Idx;
    nodeIdxNew_alreadyPresent = full(IDToIdxMap(attachID_alreadyPresent));
    commentRepmat = repmat({flagComment},length(nodeIdxNew_alreadyPresent),1);
    skel = skel.setComments(tr,nodeIdxNew_alreadyPresent,commentRepmat);
end

% Check
assert(length(interpNodeCoords) == length(attachID_valid),...
    ['interpolated nodes numbers does not match the nodes ',...
    'we would like to connect them to']);
% Add the interpolated nodes to the skeleton
skelInterpolated = skel;
for i = 1:length(interpNodeCoords)
    assert(ismember(attachIdx_valid(i),BorderEdges(i,:)),...
        'The original Idx is not included in the border edge');
    skelInterpolated = skelInterpolated.addNode ...
        (tr,interpNodeCoords{i}, attachID_valid(i), [], flagComment);
end
end

