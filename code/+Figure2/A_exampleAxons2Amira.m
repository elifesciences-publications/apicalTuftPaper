% Figure 2A: example axons seeded from shaft and spine of apical dendrites.
% This script writes the appropriate files for import into AMIRA

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% Set-up
util.clearAll
outputFolder = fullfile(util.dir.getFig(2),'A','AmiraForSpineTargetingRatio');
util.mkdir(outputFolder);
c = util.plot.getColors();

inputSkel = {{'PPC_inhibitoryAxon','singleSpineLumped'},...
    {'PPCspineSeeded_spineRatioMappingL2'}};
treeNames = {'inhibitoryAxonLayer2ApicalDendriteSeeded02',...
    'layer2ApicalDendriteSeeded25'};
fnames = {'ShaftSeeded','SpineSeeded'};

colors = {c.inhcolor,c.exccolor};
synCoords = cell(1,2);
for i = 1:2
    % Only keep the target tree in each annotation
    curName = fullfile(outputFolder,fnames{i});
    skel = apicalTuft(inputSkel{i}{:});
    trID = skel.getTreeWithName...
        (treeNames{i});
    skel = skel.deleteTrees(trID,true);
    % Get synapse coordinates and the axon backbone (remove synapse annotation nodes)
    synCoords{i} = skel.getSynCoord;
    skelTrimmed = skel.getBackBone;
    % Convert synapse table coordinate into a single array
    if ~iscell(synCoords{i}{1,2})
        % Hack: when the array has size 1 along one dimension, it comes out as
        % an array instead of a cell, Thus it has to be treated differently
        thisCoord = synCoords{i}{1,2};
        synCoords{i} = [thisCoord;cat(1,synCoords{i}{1,3:end}{:})];
    else
        synCoords{i} = cat(1,synCoords{i}{1,2:end}{:});
    end
    % Add the seed synapse as well
    synCoords{i} = [synCoords{i};skel.getNodes([],skel.getSeedIdx)];
    % Write the skeleton as a hoc file
    util.amira.convertKnossosNmlToHocAll...
        (skelTrimmed,curName);
    % Write synapses as spheres for input to Amira 3D visualization
    % software
    synCoordsNM = synCoords{i}.*skel.scale;
    util.amira.writeSphere(synCoordsNM,1000,[curName,'.ply'],colors{i});
end