function [prop] = spineRatioMappingL2()
% spineRationMappingL2 outputs properties used by the apical tuft class for the
% annotations of output synapses of axons seeded from spines of ADs in L2
% datasets. The shaft-seeded axons are the same as inhibitory axons used in
% specificity analysis. See config. singleSpinesLumped

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop.outputDir = util.dir.getSpineFractionMapping;
prop.apicalType = { 'layer2ApicalDendriteSeeded',...
    'deepLayerApicalDendriteSeeded'};
prop.syn = {'shaft','spine_DoubleInnervaterd','spine_neck'...
    ,'cellBody','spine_singleInnervaterd',}';
prop.synExclusion = 'unsureSynapse';
prop.synGroups = {{1:4}'}';
prop.synLabel = {'Shaft','Spine'}';
prop.seed = 'seed';
% Just added for the backbone extraction from L2_25 axon used in Fig. 2A
prop.fixedEnding = {'exit','dead end'}';
end

