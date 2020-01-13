function [objNew] = splitCC(obj,treeIndices, doVanillaSplit,...
    addSplitLoc2TreeName)
%SPLITCC This function splits connected components of trees into separate
%trees. Used after chopping the dataset into slices for example
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('doVanillaSplit','var') || isempty(doVanillaSplit)
    doVanillaSplit = false;
end
% adds the split coordinate to the name of the tree. 
% It needs the 'newEndings' Comment to perform this.
if ~exist('addSplitLoc2TreeName','var') || isempty(addSplitLoc2TreeName)
    addSplitLoc2TreeName = false;
end
% Note: completely empty trees create errors in skeleton.splitCC
% Make sure all grouping variables are empty in these annotations
if all(cellfun(@isempty,obj.nodes))
    objNew = obj;
    objNew.l2Idx = [];
    objNew.dlIdx = [];
    objNew.connectedComp.synIDPost = table();
    objNew.connectedComp.emptyTracing = true;
    for i = 1:width(objNew.groupingVariable)
        objNew.groupingVariable{1,i}{1} = [];
    end
    return;
end
% Split the connected components
[objNew,origTreeIdx, ~,origNodeIDs] = splitCC@skeleton(obj,treeIndices);
objNew.names = obj.names(origTreeIdx);
if addSplitLoc2TreeName
    endingNodes = objNew.getNodes...
        ([],objNew.getNodesWithComment('newEndings'));
    assert(size(endingNodes,1) == objNew.numTrees);
    objNew.names = cellfun(@(y,x) [y,'_',sprintf('%0.3u_%0.3u_%0.3u',x)],objNew.names,...
        num2cell(endingNodes,2),'UniformOutput',false);
end
% Convert to apicaltuft object
objNew = apicalTuft.skeletonConverter(objNew,obj);
% Gather a list of synapse ID (from original annotation) plus the synapse
% number for each CC
objNew.connectedComp.treeIdx = origTreeIdx;
objNew.connectedComp.nodeID = origNodeIDs;
% Flags for knowing that this object comes from a splitting procedure and
% is not empty
objNew.connectedComp.splitDone = true;
objNew.connectedComp.emptyTracing = false;
objNew=objNew.updateGrouping;
% Only do a vanilla version of splitting no synapses invovlved if requested
% Use case distal vs bifurcation analysis on Jan 2019
if doVanillaSplit
    objNew.connectedComp.splitDone = false;
    return
end
objNew.connectedComp.synIDPost = objNew.createEmptyTable([],...
    objNew.connectedComp.synIDPre.Properties.VariableNames);
findSynInCC=@(allSynIDs, ccIDs) ...
    allSynIDs(ismember(allSynIDs(:,1),intersect(allSynIDs(:,1),ccIDs)),:);
objNew.connectedComp.synIDPost{:,2:end} = ...
    cellfun(findSynInCC, ...
    objNew.connectedComp.synIDPre{origTreeIdx,2:end},...
    repmat(origNodeIDs,1,width(objNew.connectedComp.synIDPre)-1),...
    'UniformOutput',false);
% Flags for knowing that this object comes from a splitting procedure and
% is not empty
objNew.connectedComp.splitDone = true;
objNew.connectedComp.emptyTracing = false;
end