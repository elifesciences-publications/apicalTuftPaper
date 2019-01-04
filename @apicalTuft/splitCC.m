function [objNew] = splitCC(obj,treeIndices)
%SPLITCC This function splits connected components of trees into separate
%trees. Used after chopping the dataset into slices for example
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
% Note: completely empty trees create errors in skeleton.splitCC
% Make sure all grouping variables are empty in these annotations
if all(cellfun(@isempty,obj.nodes))
    objNew=obj;
    objNew.l2Idx=[];
    objNew.dlIdx=[];
    objNew.connectedComp.synIDPost=table();
    objNew.connectedComp.emptyTracing=true;
    for i=1:width(objNew.groupingVariable)
        objNew.groupingVariable{1,i}{1}=[];
    end
    return;
end
% Split the connected components
[objNew,origTreeIdx, ~,origNodeIDs]=splitCC@skeleton(obj,treeIndices);
% Convert to apicaltuft object
objNew.names=obj.names(origTreeIdx);
objNew=apicalTuft.skeletonConverter(objNew,obj);
% Gather a list of synapse ID (from original annotation) plus the synapse
% number for each CC
objNew.connectedComp.treeIdx=origTreeIdx;
objNew.connectedComp.nodeID=origNodeIDs;

objNew.connectedComp.synIDPost=objNew.createEmptyTable([],...
objNew.connectedComp.synIDPre.Properties.VariableNames);
findSynInCC=@(allSynIDs, ccIDs) ...
    allSynIDs(ismember(allSynIDs(:,1),intersect(allSynIDs(:,1),ccIDs)),:);
objNew.connectedComp.synIDPost{:,2:end}=...
    cellfun(findSynInCC, ...
    objNew.connectedComp.synIDPre{origTreeIdx,2:end},...
    repmat(origNodeIDs,1,width(objNew.connectedComp.synIDPre)-1),...
    'UniformOutput',false);
% Flags for knowing that this object comes from a splitting procedure and
% is not empty
objNew.connectedComp.splitDone=true;
objNew.connectedComp.emptyTracing=false;
objNew=objNew.updateGrouping;
end