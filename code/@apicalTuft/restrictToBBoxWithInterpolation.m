function [skel,toKeepNodes] = restrictToBBoxWithInterpolation...
    (skel, bbox, treeIndices,comment2Add)
% Restrict nodes of a Skeleton to a cubic bounding box. All
% nodes outside of this bounding box will be deleted.
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

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(skel.nodes);
end
if ~exist('comment2Add','var') || isempty(comment2Add)
    comment2Add = '';
end
closeGap = false;
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
    (skel,originalSkeleton,toDelNodes,tr,bbox,comment2Add)

% Default: Comment added to new cut edges
if ~exist('comment2Add','var') || isempty(comment2Add)
    comment2Add = '';
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
[ylocation2Interpolate, validInterpolationFlag] = cellfun(@(nodes)...
    util.crossBboxAndEdges(nodes,bbox,dim2InterpolateAlong), ...
    nodesOfTheEdges,'UniformOutput',false);

% Actual interpolation
interpolatedNodes = cellfun...
    (@ (x,y)util.math.linearInterpolation3(x,y,dim2InterpolateAlong),...
    nodesOfTheEdges,ylocation2Interpolate,'UniformOutput',false);

% Find the row index of the node to connect. This is the node of the edge
% that is not deleted.
nodeIdx2Attach = zeros(size(BorderEdges,1),1);
for i = 1:size(BorderEdges,1)
    % Note: output of the intersect is set to sorted by default
    nodeIdx2Attach(i,1) = intersect(BorderEdges(i,:),toKeepNodes,'stable');
end
% Now get the node ID which could be used to get the node Idx in the new
% tree
idx2ID = originalSkeleton.nodeIdx2Id{tr};
nodeID2Attach = idx2ID(nodeIdx2Attach);

% Note: Only keep the interpolated nodes that do not match an actual node in the
% annotation. This is the case when the edge node coincides with the bbox
% edge
if ~isempty(validInterpolationFlag)
    validInterpolationFlag = cell2mat(validInterpolationFlag);
    nodeID_valid = nodeID2Attach(validInterpolationFlag);
    nodeID_alreadyPresent = nodeID2Attach(~validInterpolationFlag);
    interpolatedNodes = interpolatedNodes(validInterpolationFlag);
    nodeIdx2Attach = nodeIdx2Attach(validInterpolationFlag);
    BorderEdges = BorderEdges(validInterpolationFlag,:);
    % Add the "end" comment to the nodes which are already present
    % (original, not interpolated edge nodes)
    if ~isempty(nodeID_alreadyPresent)
        IDToIdxMap = skel.nodeId2Idx;
        nodeIndices2AddEndComment = full(IDToIdxMap(nodeID_alreadyPresent));
        commentRepmat = repmat({comment2Add},length(nodeIndices2AddEndComment),1);
        skel = skel.setComments(tr,nodeIndices2AddEndComment,commentRepmat);
    end
else
    error('the valid interpolation flag should not be empty')
end
% Check
assert(length(interpolatedNodes) == length(nodeID_valid),...
    ['interpolated nodes numbers does not match the nodes ',...
    'we would like to connect them to']);
% Add the interpolated nodes to the skeleton
skelInterpolated = skel;
for i = 1:length(interpolatedNodes)
    assert(ismember(nodeIdx2Attach(i),BorderEdges(i,:)),...
        'The indices do not match ');
    skelInterpolated = skelInterpolated.addNode ...
        (tr,interpolatedNodes{i}, nodeID_valid(i), [], comment2Add);
end
end

