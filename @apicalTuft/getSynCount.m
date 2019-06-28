function [ synapseCount] =...
    getSynCount( skel, treeIndices,switchCorrectionFactor)
% getSynCount returns the number of synapses per synapse group
% INPUT:
%       treeIndices: (Default:all trees) [1xN] or [Nx1] vector (colum or row)
%           Indices of trees
% OUTPUT:
%       synapseCount: table length(treeIndices) x length(SynapseFlags)+1
%           Containing single number showing the number of the
%           synapse type in the specific tree of the synapse Coords
%       switchCorrectionFactor: the fraction of axons in each group that
%       converts to the other. Used for correction of spine and shaft
%       synapses which are inhibitory and excitatory, respectively.
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
if ~exist('switchCorrectionFactor','var') || ...
        isempty(switchCorrectionFactor)
    switchCorrectionFactor = zeros(size(skel.synLabel));
end
% return empty table if empty annotation
if skel.connectedComp.emptyTracing
    synapseCount=table();
    return
end
if skel.connectedComp.splitDone
    synapseCount=skel.createEmptyTable(treeIndices,...
        skel.connectedComp.synIDPost.Properties.VariableNames);
    synapseCount{:,2:end}=...
        cellfun(@(x) sum(x(:,2)),...
        skel.connectedComp.synIDPost{treeIndices,2:end},'UniformOutput',false);
    synapseCount=[synapseCount(:,1),...
        util.varfunKeepNames(@cell2mat,synapseCount(:,2:end))];
else
    % Get node indices of the synapse groups
    synIdx=skel.getSynIdx( treeIndices);
    % Initialize synapse count the same way as the SynIdx
    synapseCount=array2table( zeros(size(synIdx,1),size(synIdx,2)-1),'VariableNames', ...
        synIdx.Properties.VariableNames(2:end));
    
    % get the synapse count
    synapseCount.Variables=cellfun(@length,...
        synIdx(:,2:end).Variables);
    % Apply the correction factor
    synapseCount.Variables=round(fliplr(...
        synapseCount.Variables.*switchCorrectionFactor)+...
        synapseCount.Variables);
    % Transfer treeIdx
    synapseCount=cat(2,synIdx(:,1),synapseCount);
end
end

