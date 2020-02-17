function [unsureIdx] = getUnsureIdx(obj,treeIndices)
%GETUNSUREIDX Summary of this function goes here
%   Detailed explanation goes here
% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
% convert a character array to a single cell
if ~iscell(obj.synExclusion)
    obj.synExclusion={obj.synExclusion};
end
% Get the unsure synapse Ids
for tr=treeIndices(:)'
    for synExc=1:length(obj.synExclusion)
        curTreeIdx{synExc}=obj.getNodesWithComment(obj.synExclusion{synExc},...
            tr,'partial');
    end
    unsureIdx{tr}=cat(1,curTreeIdx{:});
end

end

