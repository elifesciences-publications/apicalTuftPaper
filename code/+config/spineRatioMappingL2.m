function [prop] = spineRatioMappingL2()
%spineRationMapping properties used by the apical tuft class for the
% annotation of output synapse to classify the axon type (spine targeting: 
% excitatory, shaft targeting : inhibitory)

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

