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
% Tables to carry the output
NrOfObliques = table(zeros(size(treeIndices(:))),...
    'RowNames',skel.names(treeIndices), 'VariableNames',{'numObliques'});
ListOfCoords = table(cell(size(treeIndices(:))),...
    'RowNames',skel.names(treeIndices), 'VariableNames',{'coordinates'});
% Loop over trees
for i = 1:length(treeIndices)
    tr = treeIndices(i);
    % Get bifurcaiton and soma ID and Idx
    bifurIdx = skel.getNodesWithComment('bifurcation',tr);
    bifurID = Idx2IdConverter{i}(bifurIdx);
    somaIdx = skel.getNodesWithComment('soma',tr);
    somaID = Idx2IdConverter{i} (somaIdx);
    % Check for both nodes to be unique
    assert(length(bifurID) == 1 && length(somaID) == 1, 'Length Check');
    % Get the path (node Indices) between the soma and the bifurcation
    [curPath, curTreeIdx, ~] = ...
        skel.getShortestPath (somaID,bifurID);
    % Take out the soma and the bifurcation node themselves
    onlyTrunkPath = setdiff(curPath,[bifurIdx,somaIdx]);
    assert(curTreeIdx == tr, 'Tree Idx check');
    ADTrunkDegree = allNodeDegrees{i}(onlyTrunkPath);
    % All nodes on the path between MB and soma had
    assert(~any((ADTrunkDegree - 2) < 0), ...
        'Some nodes have degrees smaller than 2');
    % Any node that has a degree above 2 is assumed to be connected to
    % Obliques. The number of obliques connected to that node is the
    % degrees above 2. Therefore a degree 4 node has 2 obliques connected
    % to it
    NrOfObliques{i,1}  = sum(ADTrunkDegree-2);
    % Output coordinate of the location of obliques for double checking
    BranchNodes = find(ADTrunkDegree > 2);
    if ~isempty(BranchNodes)
        ListOfCoords{i,1}{1} = skel.getNodes(tr, onlyTrunkPath(BranchNodes));
    end
end
end

