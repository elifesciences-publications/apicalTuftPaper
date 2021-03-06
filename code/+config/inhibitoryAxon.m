function [prop] = inhibitoryAxon()
% INHIBITORYAXONS properties used by the apical tuft class for the
% inhibitory axon annotations of axons targeting ADs

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir = util.dir.getInhibitoryAxon;
prop.apicalType = { 'inhibitoryAxonLayer2ApicalDendriteSeeded',...
    'inhibitoryAxonDeepLayerApicalDendriteSeeded'}';
prop.syn = {'shaftOfL2ApicalDendrite',...
    'shaftOfDeepApicalDendrite',...
    'shaftOfOtherDendrite',...
    'spineOfL2ApicalDendrite_DoubleInnervated',...
    'spineOfL2ApicalDendrite_neck',...
    'spineOfL2ApicalDendrite_singleInnervated',...
    'spineOfDeepApicalDendrite_DoubleInnervated',...
    'spineOfDeepApicalDendrite_neck',...
    'spineOfDeepApicalDendrite_singleInnervated',...
    'spineOfOtherDendrite_DoubleInnervated',...
    'spineOfOtherDendrite_neck',...
    'spineOfOtherlDendrite_singleInnervated',... % the "l" in "OtherlDe" is a typo but we keep it as is since all the comments have the same issue
    'layer2CellBody',...
    'axonInitialSegment','Glia'}';
prop.synExclusion = 'unsureSynapse';
prop.synGroups = {{1,4,5,6}',{2,7,8,9}',{10,11}'}';
prop.synLabel = {'L2Apical','DeepApical','Shaft','SpineDouble',...
    'SpineSingle','Soma','AIS','Glia'}';
prop.synCenterTPA = false;
prop.seed = 'seed';
prop.fixedEnding = {'end','exit','dead end'}';
end

