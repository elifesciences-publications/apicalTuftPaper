function [objCropped] = cropoutLowRes...
    (obj,treeIndices,dimLowresBorder,edgeLowRes)
% CROPOUTLOWRES crop the lowres part of the dataset by using the
% highresBorder
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('dimLowresBorder','var') || isempty(dimLowresBorder)
    dimLowresBorder = obj.datasetProperties.dimPiaWM;
end
if ~exist('edgeLowRes','var') || isempty(edgeLowRes)
    edgeLowRes = obj.datasetProperties.highResBorder;
end
Bbox=obj.getBbox;

Bbox(dimLowresBorder,2)=edgeLowRes;
comment2Add='newEndings';
objCropped=obj.restrictToBBoxWithInterpolation(Bbox,treeIndices,...
    comment2Add);
objCropped.fixedEnding=[objCropped.fixedEnding,{comment2Add}];
end

