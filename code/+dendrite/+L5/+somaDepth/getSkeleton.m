function [somaDepth] = getSkeleton(skel,treeIndices)
% GETSKELETON get the somatic depth of neurons in LPtA and PPC-2 datasets.
% Use comment 'soma'. In PPC, actual surfaces fit to approximate skeletons
% are used to get the distance to pia. In LPtA, One of the axes is matched
% to pia using the convert2piacoord method of apicalTuft class before
% handing it to this function

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = skel.groupingVariable.Variables;
end
switch skel.filename
    case 'PPC2_l2vsl3vsl5'
        pia = util.plot.loadPia;
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
    assert(all(cellfun(@length,curNodes) == 1), 'Uniqueness Check');
    curSomaCoords = skel.getNodes(curTr,curNodes);
    % convert to NM for plotting and distance to pia measurement and make
    % the first dimension XYZ
    curSomaCoordsInNM = round(curSomaCoords.*skel.scale)';
    % Measurement of distance to pia
    if measureRel2Pia
        somaDepth{cellT} = ...
            dendrite.L5.somaDepth.dist2plane...
            (pia.fitSurfaceNM,curSomaCoordsInNM)./1000;
    else
        % Use the Y coordinate as soma depth
        % Note: the skeleton should be converted using convert2piacoord
        % previously so that the y coordinate corresponds to the depth of
        % the somate relative to pia
        somaDepth{cellT} = curSomaCoordsInNM(2,:)./1000;
    end
end
end

