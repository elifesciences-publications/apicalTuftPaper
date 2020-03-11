function [NrOfObliques, ListOfCoords] = ...
    getNumberOfObliques(skel,treeIndices)
% GETNUMBEROFOBLIQUES Extract the number of oblique dendrite in each Apical
% dendrite annotation
% Note: this function assumes any node above degree 2 between soma and the
% main bifurcaiton is an individual oblique dendrite
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
Idx2IdConverter = skel.nodeIdx2Id (treeIndices);
allNodeDegrees = skel.calculateNodeDegree(treeIndices);

NrOfObliques = table(zeros(size(treeIndices(:))),...
    'RowNames',skel.names(treeIndices), 'VariableNames',{'numObliques'});
ListOfCoords = table(cell(size(treeIndices(:))),...
    'RowNames',skel.names(treeIndices), 'VariableNames',{'coordinates'});
for i = 1:length(treeIndices)
    tr = treeIndices(i);
    % Get bifurcaiton and soma ID and Idx
    bifurIdx = skel.getNodesWithComment('bifurcation',tr);
    bifurID = Idx2IdConverter{i}(bifurIdx);
    somaIdx = skel.getNodesWithComment('soma',tr);
    somaID = Idx2IdConverter{i} (somaIdx);
    assert(length(bifurID) == 1 && length(somaID) == 1);
    [curPath, curTreeIdx, ~] = ...
        skel.getShortestPath (somaID,bifurID);
    onlyTrunkPath = setdiff(curPath,[bifurIdx,somaIdx]);
    assert(curTreeIdx == tr);
    ADTrunkDegree = allNodeDegrees{i}(onlyTrunkPath);
    assert(~any( ADTrunkDegree-2<0), ...
        'Some nodes have degrees smaller than 2');
    NrOfObliques{i,1}  = sum(ADTrunkDegree-2);
    % Also output the location of obliques for double checking
    BranchNodes = find(ADTrunkDegree > 2);
    if ~isempty(BranchNodes)
        ListOfCoords{i,1}{1} = skel.getNodes(tr, onlyTrunkPath(BranchNodes));
    end
end
end

