function [prop] = l2vsl3vsl5Diameter()
% Diameter measurements in LPTA and PPC2 datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=fullfile(util.dir.getAnnotation,'l2vsl3vsl5');
prop.apicalType={ 'layer2ApicalDendrite_mapping',...
    'layer3ApicalDendrite_mapping','layer5ApicalDendrite_mapping',...
    'layer2ApicalDendrite_dist2soma',...
    'layer3ApicalDendrite_dist2soma','layer5ApicalDendrite_dist2soma'};
prop.fixedEnding={'start','end','exit','soma','bifurcation'}';
prop.legacyGrouping=false;

end