function [synapseIdx] = getSynIdx(skel, treeIndices,verbose)
% getSynIdx gets the synapse Ids based on the synapse
% flags passsed to it. This is done by excluding the comments having the
% exclusion flag
% INPUT: 
%       treeIndices: (Optional:all trees) vector(colum or row)
%           Contains indices of trees for which the synapse are extracted
%       verbose: logical (default: false)
%           report synapse labels grouped together
% OUTPUT: 
%       synapseIdx: table length (treeIndices) x length (SynapseFlags)
%                   Containing double arrays of the synapse node Indices

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set defaultTree Nr
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
if ischar(skel.synExclusion)
    skel.synExclusion = {skel.synExclusion};
end
if ~isempty(skel.seed)
    skel.synExclusion = cat(2,skel.synExclusion,skel.seed);
end
if nargin<3
    verbose = false;
end

% Report synapse groups
if verbose
    for i = 1:length(skel.synGroups)
        disp([{['Group(',num2str(i),'): ']},...
            skel.syn(cell2mat(skel.synGroups{i}))])
    end
end

IdxToKeep = 1:length(skel.syn);
synapseIdx = {};
% make sure each tree has 1 and only 1 seed synapse In axon cases
skel.checkSeedUniqueness(treeIndices)

for tr = treeIndices(:)'
    % Get synapse Idx function
    getPartialComment = @(comment)skel.getNodesWithComment...
        (comment,tr,'partial');
    % Get the Idx to exclude
    exclude = cellfun(getPartialComment...
        ,skel.synExclusion,'UniformOutput',false);
    excludeIdx = util.convertCell2Array(exclude);
    synIdx = cellfun(getPartialComment...
        ,skel.syn,'UniformOutput',false);
    removeUnsure = @(synGroup)setdiff(synGroup,excludeIdx);
    % remove synapses to exclude (unsure, seed synapse in axon annotations)
    thisTreeSyn = cellfun(removeUnsure,synIdx,...
        'UniformOutput',false);
    thisTreeSyn = cellfun(@(x) x(:),thisTreeSyn,'UniformOutput',false);
    
    % Merge synapses from multiple comment strings into one synapse group 
    if ~isempty(skel.synGroups)
        IdsToDelete = [];
        for synGroup = 1:length(skel.synGroups)
            mergeIdx = cell2mat(skel.synGroups{synGroup});
            % TreeIds first column
            IdToMerge = min(mergeIdx);
            thisTreeSyn{IdToMerge} = ...
                cat(1,thisTreeSyn{mergeIdx});
            IdsToDelete = [IdsToDelete,setdiff(mergeIdx,IdToMerge)'];
        end
        IdxToKeep = setdiff(1:length(thisTreeSyn),IdsToDelete);
    end
    
    % Deprecated: Remove synapses from a mother string group which do not belong to it
    if ~isempty(skel.synGroups2remove)
        for synGroup = 1:length(skel.synGroups2remove)
            curIds = cell2mat(skel.synGroups2remove{synGroup})';
            motherId = curIds(1);
            motherSynIds = thisTreeSyn{motherId};
            childsToRemove = cat(1,thisTreeSyn...
                {curIds(2:end)});
            if ~isempty(childsToRemove)
                assert(all(ismember(childsToRemove,motherSynIds)),...
                    'All child synapses should be contained in the mother category');
                motherSynIdClean = setdiff(motherSynIds,childsToRemove);
                thisTreeSyn{motherId} = motherSynIdClean;
            end
        end
    end
    % Keep the groups that are not merged into other groups
    thisTreeSynAdditionalGroupsDeleted = thisTreeSyn(IdxToKeep);
    % Make sure groups don't overlap
    apicalTuft.pairwiseIntersection(thisTreeSynAdditionalGroupsDeleted);
    % Add row for current tree
    synapseIdx = [synapseIdx;[skel.getTreeIdentifier(tr),...
        thisTreeSynAdditionalGroupsDeleted]]; %#ok<*AGROW>
end

% Get synapse center from TPA if necessary
if skel.synCenterTPA
    synapseIdx(:,2:end) = skel.getSynCenterFromTPA(treeIndices,...
        synapseIdx(:,2:end));
end

% Make sure synLabel exists
if isempty(skel.synLabel)
    skel.synLabel = skel.syn(IdxToKeep);
end

% Convert to Table
assert(size(synapseIdx,2) == length(skel.synLabel)+1)
synapseIdx = cell2table(synapseIdx,'VariableNames' ,...
    cellstr([{'treeIndex'},Util.makeVarName(skel.synLabel)]));
end

