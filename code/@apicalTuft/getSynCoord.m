function [ synapseCoords] =...
    getSynCoord( skel, treeIndices,toNM,RotationMatrix)
% getSynCoord this Method returns the coordinate of synapses
% INPUT : treeIndices
% OUTPUT synapseCoords: table length(treeIndices)xlength(SynapseFlags)+1
%                   Containing 3xN double arrays of the synapse Coords
%                   (treeInformation) in voxel dimensions
%        toNM: boolean
%               Tag to decide to output the synapse coordinate in NM
%        RotationMatrix: 3 x 3 double
%               Rotation matrix of the dataset for pia on ton
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
if ~exist('toNM','var') || isempty(toNM)
    toNM = false;
end
if toNM
    scale = skel.scale;
else
    scale = [1,1,1];
end
%Get synapse Idx
synIdx = skel.getSynIdx(treeIndices);

%Get Coords now
synapseCoords = cell(size(synIdx));
for tr = 1:size(synIdx,1)
    for synType = 2:size(synIdx,2)
        trIndex = treeIndices(tr);
        synapseCoords{tr,synType} = ...
            skel.getNodes(trIndex,synIdx{tr,synType}).*scale;
    end
end
%Move over the tree Indices
synapseCoords(:,1) = synIdx(:,1).Variables;
synapseCoords = cell2table(synapseCoords,...
    'VariableNames',synIdx.Properties.VariableNames);
end
