function [prop] = spineRatioMappingL1()
% spineRationMappingL1 properties used by the apical tuft class for the
% annotations of axons innervating ADs in L1. Our goal is to distinguish
% spine-prefering and shaft-prefering axons (putative Exc. and Inh.)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop.outputDir = util.dir.getSpineFractionMapping;
prop.apicalType = { 'layer2ApicalDendriteSeeded',...
    'layer3ApicalDendriteSeeded',...
    'deepLayerApicalDendriteSeeded'};
prop.syn = {'shaft', 'spine_DoubleInnervaterd', 'spine_neck'...
    , 'cellBody', 'spine_singleInnervaterd'}';
prop.synExclusion = 'unsureSynapse';
prop.synGroups = {{1:4}'}';
prop.synLabel = {'Shaft','Spine'}';
prop.seed = 'seed';
prop.legacyGrouping = false;

end

