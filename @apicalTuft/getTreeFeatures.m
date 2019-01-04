function [ treeFeatures ] = getTreeFeatures( skel,treeIndices)
% getTreeFeatures Measures the total synapse density of a
% tree
% INPUT: 
%       treeIndices: (Optional:all trees) vector(colum or row)
%       Contains indices of trees for which the synapse are extracted

% OUTPUT: 
%       treeFeatures: table length(treeIndices)x4
%                   Containing treeIDx, path length
%                   in microns,total synapse density,

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set default tree number
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

% Calculate total synapse number
treeFeatures=skel.getTotalSynNumber(treeIndices);

% Trim the skeleton to shaft for pathlength calculation if.fixedEnding is
% present in options
if ~isempty(skel.fixedEnding)
    skeltrimmed=skel.getBackBone(treeIndices,skel.fixedEnding);
else
    skeltrimmed=skel;
end
pL=skeltrimmed.pathLength...
    (treeIndices);
treeFeatures.pathLengthInMicron=pL.pathLengthInMicron;
treeFeatures.synDensity=treeFeatures.totalSynapseNumber./...
    treeFeatures.pathLengthInMicron;
end

