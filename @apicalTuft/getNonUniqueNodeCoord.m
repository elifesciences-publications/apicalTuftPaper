function [uniqueNonUniqueCoordinates] = getNonUniqueNodeCoord(obj,treeIndices)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees();
end
% Unique values
coords=obj.getNodes(treeIndices);
[~,idxu,idxc] = unique(coords,'rows');
% count unique values (use histc in <=R2014b)
[count, ~, idxcount] = histcounts(idxc,numel(idxu));
% Where is greater than one occurence
idxkeep = count(idxcount)>1;
% Extract from C
nonUniqueCoords=coords(idxkeep,:);
uniqueNonUniqueCoordinates=unique(nonUniqueCoords,'rows');
end
