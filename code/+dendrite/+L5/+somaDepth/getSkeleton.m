function [somaDepth] = getSkeleton(skel,treeIndices)
%GETSKELETON get somatic depth of trees
if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = skel.groupingVariable.Variables;
end
switch skel.filename
    case 'PPC2_l2vsl3vsl5'
        l1 = util.plot.loadPia;
        measureRel2Pia = true;
    case 'LPtA_l2vsl3vsl5'
        
        measureRel2Pia = false;
    otherwise
        error('getSkeleton only accepts data from LPtA and PPC2 datasets');
end
somaDepth = cell(size(treeIndices));
for cellT = 1:length(treeIndices)
    curTr = treeIndices{cellT};
    curNodes = skel.getNodesWithComment('soma',curTr,'insensitive');
    assert(length(curNodes) == length(curTr));
    curSomaCoords = skel.getNodes(curTr,curNodes);
    % convert to NM for plotting and distance to pia measurement and make
    % the first dimension XYZ
    curSomaCoordsInNM = round(curSomaCoords.*skel.scale)';
    % Measurement of distance to pia
    if measureRel2Pia
        somaDepth{cellT} = ...
            dendrite.L5.somaDepth.dist2plane...
            (l1.fitSurfaceNM,curSomaCoordsInNM)./1000;
    else
        % Use the Y coordinate as soma depth
        % Note: the skeleton should be converted using convert2piacoord
        % previously so that the y coordinate corresponds to the depth of
        % the somate relative to pia
        somaDepth{cellT} = curSomaCoordsInNM(2,:)./1000;
    end
end
end

