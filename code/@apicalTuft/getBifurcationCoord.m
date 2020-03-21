function [bifurcationCoord] = getBifurcationCoord(obj,treeIndices,...
    toNm, returnTable)
% GETBIFURCATIONCOORD Get the coordinate of the apical dendrite bifurcation
% using the bifurcation property of the apicalTuft object.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('toNm','var') || isempty(toNm)
    toNm = true;
end
if ~exist('returnTable','var') || isempty(returnTable)
    returnTable = false;
end
% Get node index
idx = obj.getBifurcationIdx(treeIndices);
% Get coord from index
bifurcationCoord = obj.getNodes(treeIndices,idx,toNm);
% return table with rowNames representing the names of the apical dendrite
% bifurcation
if returnTable
    bifurcationCoord = ...
        table(bifurcationCoord,'RowNames', obj.names(treeIndices));
end
end

