function [skel] = appendCommentWithIdx...
    (skel,treeIndices,nodeIdx,commentSuffix)
% appendCommentWithIdx appends the commentSuffix at specific nodeIdx

% Author: Ali Karimi<ali.karimi@brain.mpg.de>

% Set defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

for i = 1:length(treeIndices)
    for j = 1:length(nodeIdx{i})
        skel.nodesAsStruct{treeIndices(i)}(nodeIdx{i}(j)). ...
            comment = ...
            [skel.nodesAsStruct{treeIndices(i)}(nodeIdx{i}(j)).comment,...
            '_',commentSuffix];
    end
end
end

