function [prop] = spineRatioMappingL2()
% spineRationMappingL2 outputs properties used by the apical tuft class for the
% annotations of output synapses of axons seeded from spines of ADs in L2
% datasets. The shaft-seeded axons are the same as inhibitory axons used in
% specificity analysis. See config. singleSpinesLumped

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop.outputDir = util.dir.getSpineFractionMapping;
prop.apicalType = { 'layer2ApicalDendriteSeeded',...
    'deepLayerApicalDendriteSeeded'};
prop.syn = {'spine_singleInnervaterd','shaft','spine_DoubleInnervaterd','spine_neck','cellBody'}';
prop.synExclusion = 'unsureSynapse';
prop.synGroups = {{2,3,4,5}'}';
prop.synLabel = {'Spine','Shaft'}';
prop.seed = 'seed';
% Just added for the amira representation of L2_25 axon
prop.fixedEnding = {'exit','dead end'}';
end

