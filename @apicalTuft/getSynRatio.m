function [ synapseRatio] =...
    getSynRatio( skel, treeIndices)
%getSynRatio returns the ratio of each type of synapse
%INPUT treeIndices: (Optional:all trees) vector(colum or row)
%           Contains indices of trees for which the synapse are extracted
% OUTPUT synapseRatio: table length(treeIndices)xlength(SynapseFlags)
%                   Containing the ratio (summing to one for each tree) of
%                   each synapse type
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set defaultTree Nr
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

synCount=skel.getSynCount(treeIndices);
if isempty(synCount)
    synapseRatio=table();
    disp([skel.filename,': empty annotation, no synapses found']);
    return;
end
sumOfSynapses=skel.getTotalSynNumber(treeIndices);

synapseRatio=array2table( zeros(size(synCount,1),size(synCount,2)-1),...
    'VariableNames', ...
    synCount.Properties.VariableNames(2:end));
%Get the ratios
ratioFuncHandle=@(tableCount) tableCount./sumOfSynapses(:,2).Variables;
synapseRatio=varfun(ratioFuncHandle, synCount(:,2:end));
% Make sure they all sum up to 1
ratioNum=synapseRatio.Variables;
sumRatios=uint8(sum(reshape(ratioNum(~isnan(ratioNum)),[],2),2));
assert (all(sumRatios)==1,...
    'sum of all synapse ratios does not equal one');
%Transfer treeIdx
synapseRatio=cat(2,synCount(:,1),synapseRatio);
%Get read of FUN_
synapseRatio.Properties.VariableNames=synCount.Properties.VariableNames;
end