function [obj,randomSynapses] = synRandomSample...
    (obj,synType,numberOfTrees,numberOfSamplesPerTree)
% SYNRANDOMSAMPLE This function gets a random subset of synapses and adds
% "randomSynapse" to their name
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if ~exist('numberOfSamplesPerTree','var') || isempty(numberOfSamplesPerTree)
    numberOfSamplesPerTree = 1;
end
if ~exist('numberOfTrees','var') || isempty(numberOfTrees)
    numberOfTrees = 5;
end

% Get Tree IDs with more than numberOfSamplesPerTree synapses
synIdx=obj.getSynIdx;
for i=1:length(synType)
    curSynIdx=synIdx.(synType{i});
    numberOfCurSyn=cellfun(@(x) length(x),curSynIdx);
    treesThreshholded=find(numberOfCurSyn>=numberOfSamplesPerTree);
    l2Idx=intersect(obj.l2Idx,treesThreshholded);
    dlIdx=intersect(obj.dlIdx,treesThreshholded);
    
    % Get numberOfTrees random tree Indices with the threshhold number of
    % synapses
    curRandomTree{1}=util.stat.datasample(l2Idx,...
        numberOfTrees);
    curRandomTree{2}=util.stat.datasample(dlIdx,...
        numberOfTrees);
    
    % Get numberOfSamplesPerTree synapse per tree
    sampleFun=@(tr) util.stat.datasample(curSynIdx{tr},numberOfSamplesPerTree);
    curRandomSynapses=cellfun(@(tr) arrayfun(sampleFun,tr,...
        'UniformOutput',false),curRandomTree,...
        'UniformOutput',false);
    % Change the name of the synapse
    for j=1:2
        obj=obj.appendCommentWithIdx(curRandomTree{j},curRandomSynapses{j},...
            'randomSynapse');
    end
    randomSynapses.syn.(synType{i})=curRandomSynapses;
    randomSynapses.tree.(synType{i})=curRandomTree;
end
end

