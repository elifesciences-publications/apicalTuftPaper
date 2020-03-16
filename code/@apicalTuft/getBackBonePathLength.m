function [pathLengthInMicron] = getBackBonePathLength(obj,treeIndices)
% GETBACKBONEPATHLENGTH Get the pathlenth (in microns) of the 
% the backbone of a tree. The backbone excludes spine necks and the nodes
% used for annotation of synapses. See obj.fixedEnding

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end

% Trim the skeleton to shaft Backbone (in case obj.fixedEnding exists)
if ~isempty(obj.fixedEnding)
    skeltrimmed = obj.getBackBone(treeIndices,obj.fixedEnding);
else
    skeltrimmed = obj;
end

% Measure pathlength of BackBone
pathLengthInMicron = skeltrimmed.pathLength...
    (treeIndices);

end

