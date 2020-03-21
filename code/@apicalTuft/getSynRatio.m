function [synapseRatio] =...
    getSynRatio(skel, treeIndices, switchCorrectionFactor)
% getSynRatio returns the ratio of each type of synapse

% INPUT: 
%       treeIndices: (Optional:all trees) vector(colum or row)
%           Contains indices of trees for which the synapse are extracted
% OUTPUT: 
%       synapseRatio: table length(treeIndices)xlength(SynapseFlags)
%                   Containing the ratio (summing to one for each tree) of
%                   each synapse type

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
if ~exist('switchCorrectionFactor','var') || ...
        isempty(switchCorrectionFactor)
    switchCorrectionFactor = zeros(size(skel.synLabel));
end

% Get the number (count) of synapses
synCount = skel.getSynCount(treeIndices,switchCorrectionFactor);
if isempty(synCount)
    synapseRatio = table();
    disp([skel.filename,': empty annotation, no synapses found']);
    return;
end
sumOfSynapses = skel.getTotalSynNumber(treeIndices);

% Get the ratios
ratioFuncHandle = @(tableCount) tableCount./sumOfSynapses(:,2).Variables;
synapseRatio = varfun(ratioFuncHandle, synCount(:,2:end));

% Make sure they all sum up to 1
ratioNum = synapseRatio.Variables;
treesWithValidRatios = ~any(isnan(ratioNum),2);
sumRatios = uint8(sum(ratioNum(treesWithValidRatios,:),2));
assert (all(sumRatios) == 1,...
    'sum of all synapse ratios does not equal one');
% Transfer treeIdx
synapseRatio = cat(2,synCount(:,1),synapseRatio);
% Get rid of FUN_
synapseRatio.Properties.VariableNames = synCount.Properties.VariableNames;
end