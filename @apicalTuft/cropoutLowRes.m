function [objCropped] = cropoutLowRes...
    (obj,treeIndices,dimLowresBorder)
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
Bbox=obj.getBbox;
edgeLowRes=...
    obj.datasetProperties.highResBorder;
Bbox(dimLowresBorder,2)=edgeLowRes;
objCropped=obj.restrictToBBoxWithInterpolation(Bbox,treeIndices);
end

