function [ distTable ] = getSomaDistance( skel,treeIndices,fromString)
%GETDIST2SOMA Measure distance between 'soma' and fromString property in
%an annotation
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
if ~exist('fromString','var') || isempty(fromString)
    fromString='bifurcation';
end
% Get the location of the other point to compare to soma
locationIdx=skel.getNodesWithComment(fromString,...
    treeIndices,'partial');
% Make sure it is a cell
if ~iscell(locationIdx)
    locationIdx={locationIdx};
end
% check point uniqueness per tree
assert(all(cellfun(@length,locationIdx) == 1),...
        'location comment is not unique');
distance=cell(length(treeIndices),1);
% Get all path for the treeIndices
allPaths=skel.getShortestPaths(treeIndices(:)');

for i=1:length(treeIndices)
    % Get values for the current tree
    tr=treeIndices(i);
    curlocationIdx=locationIdx{i};
    curAllPaths=allPaths{1,i};
    try
        somaIdx=skel.getNodesWithComment(skel.soma,tr,'partial');
        assert(length(somaIdx) == 1);
        distance{i}=curAllPaths(curlocationIdx,somaIdx)./1000;
    catch
        disp('soma location not found')
        distance{i}=[];
    end
end
% Return as a table
distTable=skel.createEmptyTable(treeIndices,{'treeIdx','distance2Soma'},'cell');
distTable.distance2Soma=distance;

end

