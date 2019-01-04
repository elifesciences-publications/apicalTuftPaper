function [ synapseCoords] =...
    getSynCoord( skel, treeIndices)
% getSynCoord this Method returns the coordinate of synapses
% INPUT : treeIndices
% OUTPUT synapseCoords: table length(treeIndices)xlength(SynapseFlags)+1
%                   Containing 3xN double arrays of the synapse Coords
%                   (treeInformation) in voxel dimensions
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
%Get synapse Idx
synIdx=skel.getSynIdx(treeIndices);

%Get Coords now
synapseCoords=cell(size(synIdx));
for tr=1:size(synIdx,1)
    for synType=2:size(synIdx,2)
        trIndex=treeIndices(tr);
        synapseCoords{tr,synType} = ...
            skel.getNodes(trIndex,synIdx{tr,synType});
    end
end
%Move over the tree Indices
synapseCoords(:,1)=synIdx(:,1).Variables;
synapseCoords=cell2table(synapseCoords,...
    'VariableNames',synIdx.Properties.VariableNames);
end
