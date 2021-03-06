function [prop] = l2vsl3vsl5Diameter()
% Diameter measurements in LPTA and PPC2 datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir = fullfile(util.dir.getAnnotation,'l2vsl3vsl5Diameter');
prop.apicalType = { 'layer2ApicalDendrite_mapping',...
    'layer3ApicalDendrite_mapping','layer5ApicalDendrite_mapping',...
    'layer2MNApicalDendrite_mapping','layer5AApicalDendrite_mapping'};
prop.fixedEnding = {'start','end','exit','soma','bifurcation',...
    'dead end','newEndings'}';
prop.legacyGrouping = false;

end