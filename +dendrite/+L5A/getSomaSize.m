function [diameter] = getSomaSize(skel,treeNames)
% GETSOMASIZE Get the diameter of trees with name starting from the tree
% tags(cell array 1xN) and numTrees (1xN)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

diameter = table(zeros(size(treeNames(:))),...
    'RowNames',treeNames, 'VariableNames',{'somaDiameter'});
for i=1:length(treeNames)
    curTreeNames=...
        arrayfun(@(x)  sprintf([treeNames{i},'_%0.2u'],x),1:3,...
        'UniformOutput',false);
    % Get all the diameters for a tree
    curDiameter=...
        skel.pathLength(skel.getTreeWithName(curTreeNames))./1000;
    assert (length(curDiameter) == 3);
    % Get the diameter of sphere with equal volume to the ellipsoid
    curAvgDiameter= nthroot(prod(curDiameter),3);
    diameter{i,1}=curAvgDiameter;
    
end
end

