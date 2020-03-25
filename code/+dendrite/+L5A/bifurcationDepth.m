function [bifurDepth] = bifurcationDepth(skel,treeNames)
%BIFURCATIONDEPTH Get the depth of the bifurcaiton of L5 neurons relative
%to L1 +145
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Taken based on the average visual estimate
distL1Pia = 145;
l1 = util.plot.loadl1;
bifurDepth = table(zeros(size(treeNames(:))),...
    'RowNames',treeNames, 'VariableNames',{'bifurcationDepth'});
for i = 1:length(treeNames)
    curTr = skel.getTreeWithName(treeNames{i});
    assert (length(curTr) == 1);
    curNode = skel.getNodesWithComment(skel.bifurcation,curTr,'insensitive');
    assert(length(curNode) == 1);
    curbifurCoords= skel.getNodes(curTr,curNode);
    % convert to NM for distance measurement
    curbifurCoordsInNM = round(curbifurCoords.*skel.scale)';
    % Measurement of distance to pia
    bifurDepth{i,1} = distL1Pia-...
        (dendrite.L5A.somaDepth.dist2plane...
        (l1.fitSurfaceNM,curbifurCoordsInNM,true)./1000);
end
end

