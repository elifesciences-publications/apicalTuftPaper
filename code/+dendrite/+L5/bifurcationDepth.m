function [bifurDepth] = bifurcationDepth(skel,treeNames)
% BIFURCATIONDEPTH Get the depth of the bifurcaiton of L5 neurons relative
% to pia
% Note: This is done via calculating the depth relative to L1 and adding
% 145 um (distance from pia to L1 border). We did this since the Pia border
% would result in visually poorer results w.r.t. the angle of the apical
% dendrites relative to a horizontal line.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

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
    curbifurCoordsInNM = round(curbifurCoords .* skel.scale)';
    % Measurement of distance to pia. Use signed distance since some
    % bifurcations are within L1 (especially for L5st neurons)
    bifurDepth{i,1} = distL1Pia-...
        (dendrite.L5.somaDepth.dist2plane...
        (l1.fitSurfaceNM,curbifurCoordsInNM,true)./1000);
end
end

