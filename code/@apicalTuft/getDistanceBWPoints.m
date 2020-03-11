function [ dist2soma ] = getDistanceBWPoints( skel,treeIndices,pointNames )
% getDistanceBWPoints Get the distance between sets of points given as a
% cell array (pointNames). 
% Example pointNames: {'soma', 'bifurcation'}: measures distance between
% soma and main bifurcation
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
if ~exist('pointNames','var') || isempty(pointNames)
    pointNames={'soma','bifurcation'};
end
dist2soma=cell(length(treeIndices),1);
for i=1:length(treeIndices)
    tr=treeIndices(i);
    allPaths=skel.getShortestPaths(tr);
    nodeIndicesOfInterest=cellfun(@(name) ...
        skel.getNodesWithComment(name,tr,'partial'), pointNames);
    assert(size(nodeIndicesOfInterest,1) == 1);
    distanceMatrixBWPointsOfInterest=allPaths{1}...
        (nodeIndicesOfInterest,nodeIndicesOfInterest)./1000;
    % Return the lower triangular matrix in sparse format
    dist2soma{i}=sparse(tril(distanceMatrixBWPointsOfInterest));
    
end
% Return a scalar if only two points are used
if length(pointNames) == 2
    dist2soma=cellfun(@(x)full(x(2,1)),dist2soma);
end
end

