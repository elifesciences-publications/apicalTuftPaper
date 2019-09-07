function [vol,diameter] = getSomaSize(skel,treeTags,numTrees)
% GETSOMASIZE Get the diameter of trees with name starting from the tree
% tags(cell array 1xN) and numTrees (1xN)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

vol={zeros(1,numTrees(1)),zeros(1,numTrees(2))};
diameter={zeros(1,numTrees(1)),zeros(1,numTrees(2))};
for cellType=1:2
    for tr=1:numTrees(cellType)
        curTreeNames=...
        arrayfun(@(x) sprintf([treeTags{cellType},'%0.2u_%0.2u'],tr,x),1:3,...
            'UniformOutput',false);
        % Get all the diameters for a tree
        curDiameter=...
            skel.pathLength(skel.getTreeWithName(curTreeNames))./1000;
        curAvgDiameter=mean(curDiameter);
        % Volume of ellipsoid: V = 4/3 × π × a × b × c (radii)
        curVol=(4/3)*pi*prod(curDiameter./2);
        vol{cellType}(tr)=curVol;
        diameter{cellType}(tr)=curAvgDiameter;
    end
end
end

