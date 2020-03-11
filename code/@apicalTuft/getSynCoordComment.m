function [ synapseCoords] =...
    getSynCoordComment( skel, treeIndices, varargin)
%getSynIdxComment this Function gets the synapse Ids based on the synapse
%flags passsed to it. This is done by excluding the comments having the
%exclusion flag
%
%INPUT : for all input refer to getSynIdxComment doc
%   For default values check:getSynIdxComment
% OUTPUT synapseCoords: table length(treeIndices)xlength(SynapseFlags)+1
%                   Containing 3xN double arrays of the synapse Coords 
%                   (treeId(treeID)) in voxel dimensions
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

%Get synapse Idx
synIdx = skel.getSynIdx(treeIndices,varargin{:});

%Get Coords now
getCoordsWithTrueCellOutput = @(tr,nodeIdList)...
    skel.getNodes(tr,nodeIdList);
synapseCoords = skel.synCellTableFun(getCoordsWithTrueCellOutput,synIdx);

end
