% This script writes out the additional material for Heiko to generate the
% figures in amira
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Get the skeleton annotation with the correct names
util.clearAll;
skel = apicalTuft.getObjects('bifurcation');
% Correct the PPC skeleton to ROI2017
skel{3} = apicalTuft('PPC2017_bifurcation');


dataset = {'s1','v2','ppc','acc'};
TPA = [0,1,1,0];
makeDebugPlots = false;
for i = 1:4
    curOutputDir = fullfile(util.dir.getSurface,dataset{i});
    curSkel = skel{i};
    curDataset = dataset{i};
    if strcmp(curDataset,'s1') || strcmp(curDataset,'ppc')
        curP = surface.configIsoSurface(curDataset);
    else
        curP = surface.config_V2_ACC(curDataset);
    end
    % Only keep the relevant trees from bifurcation annotations
    Idx2Keep = curSkel.getTreeWithName(curP.treeNames,'exact');
    curSkel = curSkel.deleteTrees(Idx2Keep,true);
    % Match the order with the order of volume annotations
    [~,indexFromVolumeTreeNames2Skel] = ismember...
        (curP.treeNames,curSkel.names);
    curSkel = curSkel.reorderTrees(indexFromVolumeTreeNames2Skel);
    curSkel = curSkel.updateGrouping;
    % Get the location of spine/shaft/Inhibitory synapses and write them
    % out
    curSkel = curSkel.groupInhibitorySpines{1};
    curSkel.synCenterTPA = TPA(i);
    curSynCoords = curSkel.writeSynCoordinateTextFile([],curOutputDir);
    % Get the Backbone with spines from the tracings
    curSkel.fixedEnding = [curSkel.fixedEnding,curSkel.syn(2:4)];
    curSkelBackBone = curSkel.getBackBone([],...
    [],TPA(i),makeDebugPlots);
    for tr = 1:curSkelBackBone.numTrees
        curSkel.write...
            (curSkel.names{tr},...
            fullfile(curOutputDir,curSkel.names{tr}),tr);
    end
    surface.isoSurfaceSkeletonOverlay( curSkel,curSkelBackBone,curDataset,...
        l2color,dlcolor)
end