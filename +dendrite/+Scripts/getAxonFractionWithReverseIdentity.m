% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Note: inhibitory and excitatory in the annotation names is a misnomer 
% since these are Shaft and single-innervated Spine seeded axons
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig1,'AxonReversing');
util.mkdir(outputDir)
%% single-spine innervation fraction for axons seeded in Seeded from shaft
% spine structures on the apical dendrites of different pyramidal
% cell-types. L2,3,5 in L1 region and L2 vs L3/5 in L2 region
apTuft.L1=apicalTuft.getObjects('spineRatioMappingL1');
% The [single-innervated] Spine and Shaft seeded synapse ratios in L1
% In L1 L3 and L5 are separated
synRatio.L1=apicalTuft.applyMethod2ObjectArray(apTuft.L1,'getSynRatio');
% The [single-innervated] Spine and Shaft seeded synapse ratios in L2
% Separate .nmls
apTuft.L2.Shaft=apicalTuft.getObjects('inhibitoryAxon',...
    'singleSpineLumped');
synRatio.L2.Shaft= apicalTuft. ...
    applyMethod2ObjectArray(apTuft.L2.Shaft,'getSynRatio'); 

apTuft.L2.Spine=apicalTuft.getObjects('spineRatioMappingL2');
synRatio.L2.Spine= apicalTuft. ...
    applyMethod2ObjectArray(apTuft.L2.Spine,'getSynRatio'); 