function [prop] = spineRatioMappingL1()
% spineRationMappingL1 properties used by the apical tuft class for the
% annotations of axons innervating ADs in L1. Our goal is to distinguish
% spine-prefering and shaft-prefering axons (putative Exc. and Inh.)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop.outputDir = util.dir.getSpineFractionMapping;
prop.apicalType = { 'layer2ApicalDendriteSeeded',...
    'layer3ApicalDendriteSeeded',...
    'deepLayerApicalDendriteSeeded'};
prop.syn = {'spine_singleInnervaterd','shaft',...
    'spine_DoubleInnervaterd','spine_neck','cellBody'}';
prop.synExclusion = 'unsureSynapse';
prop.synGroups = {{2,3,4,5}'}';
prop.synLabel = {'Spine','Shaft'}';
prop.seed = 'seed';
prop.legacyGrouping = false;

end

