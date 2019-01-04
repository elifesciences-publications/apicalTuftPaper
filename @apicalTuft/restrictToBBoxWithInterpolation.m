function [skel,toKeepNodes] = restrictToBBoxWithInterpolation...
    (skel, bbox, treeIndices)
%Restrict nodes of a Skeleton to a cubic bounding box. All
%nodes outside of this bounding box will be deleted.
% INPUT bbox: [3x2] integer array containing the first and last
%             voxel of the bounding box in the respective
%             dimension.
%       treeIndices:(Optional) Vector of integer specifying the
%           trees of interest.
%           (Default: all trees).
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(skel.nodes);
end

closeGap = false;
originalSkeleton=skel;
toKeepNodes=cell(size(treeIndices));
for i = 1:length(treeIndices)
    tr=treeIndices(i);
    if ~isempty(skel.nodes{tr})
        trNodes = skel.nodes{tr}(:,1:3);
        toDelNodes = any(bsxfun(@gt,trNodes, bbox(:,2)') | ...
            bsxfun(@lt,trNodes, bbox(:,1)'),2);
        skel = skel.deleteNodes(tr, toDelNodes, closeGap);
        skel=interpolateEdges...
            (skel,originalSkeleton,toDelNodes,tr,bbox);
        % Get the ID of the nodes you keep and pass them as output
        idx2IDMap=originalSkeleton.nodeIdx2Id(tr);
        toKeepNodes{i}=idx2IDMap{1}(~toDelNodes);
    end
end

end

function skelInterpolated=interpolateEdges...
    (skel,originalSkeleton,toDelNodes,tr,bbox)
% Get a list of nodes involved on the border of the Bbox
dim=skel.datasetProperties.dimPiaWM;
toKeepNodes=find(~toDelNodes);
toDelNodes=find(toDelNodes);
edgeList=originalSkeleton.edges{tr};
BorderEdgesIdx=(ismember(edgeList(:,1),toDelNodes) & ...
    ismember(edgeList(:,2),toKeepNodes)) |...
    (ismember(edgeList(:,1),toKeepNodes) & ...
    ismember(edgeList(:,2),toDelNodes));
BorderEdges=originalSkeleton.edges{tr}(BorderEdgesIdx,:);
BorderEdgesCell=...
    mat2cell(BorderEdges,ones(length(1:size(BorderEdges,1)),1),2);
nodesOfTheEdges=cellfun(@(x) originalSkeleton.nodes{tr}(x,1:3), ...
    BorderEdgesCell,'UniformOutput',false);

% Find location on the bbox to interpolate the edges
[ylocation2Interpolate, validInterpolationFlag]=cellfun(@(nodes)...
    util.crossBboxAndEdges(nodes,bbox,dim), ...
    nodesOfTheEdges,'UniformOutput',false);

% Find the row index of the node to connect
interpolatedNodes=cellfun(@ (x,y)util.math.linearInterpolation3(x,y,dim),...
    nodesOfTheEdges,ylocation2Interpolate,'UniformOutput',false);
idx2ID=originalSkeleton.nodeIdx2Id{tr};
% Note: output of the intersect is set to sorted by default
idxOriginal=zeros(size(BorderEdges,1),1);
for i=1:size(BorderEdges,1)
    idxOriginal(i,1)=intersect(BorderEdges(i,:),toKeepNodes,'stable');
end
nodeID=idx2ID(idxOriginal);

% Note: Only keep the interpolated nodes that do not match an actual node in the
% annotation. This is the case when the edge node coincides with the bbox
% edge
if ~isempty(validInterpolationFlag)
    validInterpolationFlag=cell2mat(validInterpolationFlag);
    nodeID=nodeID(validInterpolationFlag);
    interpolatedNodes=interpolatedNodes(validInterpolationFlag);
    idxOriginal=idxOriginal(validInterpolationFlag);
    BorderEdges=BorderEdges(validInterpolationFlag,:);
end
% Add the interpolated nodes to the skeleton
assert(length(interpolatedNodes)==length(nodeID),...
    ['interpolated nodes numbers does not match the nodes ',...
    'we would like to connect them to']);
skelInterpolated=skel;
for i=1:length(interpolatedNodes)
    assert(ismember(idxOriginal(i),BorderEdges(i,:)),...
        'The indices do not match ');
    skelInterpolated=skelInterpolated.addNode ...
        (tr,interpolatedNodes{i},nodeID(i));
end
end

