function [ synSumCount ] = getTotalSynNumber( skel, treeIndices)
% getTotalSynNumber this Function gets the total number of synapses in a
% specific tree
% INPUT:
%       treeIndices: (Optional:all trees) vector(colum or row)
%           Contains indices of trees for which the synapse are extracted
% OUTPUT:
%       synSumCount: table length(treeIndices)x1
%                   Containing sum of all synapses in each tree

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set defaultTree Nr
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

% prepare the synSumCount table
synCount=skel.getSynCount(treeIndices);
synSumCount=array2table(zeros(size(synCount,1),1),'VariableNames', ...
    {'totalSynapseNumber'});
synSumCount=cat(2,synCount(:,1),synSumCount);

% here it calculates the sum
synSumCount(:,2).Variables=sum(synCount(:,2:end).Variables,2);

end

