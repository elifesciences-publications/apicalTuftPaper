function [bifurcationCoord] = getBifurcationCoord(obj,treeIndices,toNm)
%GETBIFURCATIONCOORD 
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('toNm','var') || isempty(toNm)
    toNm = true;
end
idx = obj.getBifurcationIdx(treeIndices);
bifurcationCoord = obj.getNodes(treeIndices,idx,toNm);

end

