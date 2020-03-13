function [prop] = bifurcationDiameter()
% bifurcationDiameter Diameter measurements around the main bifurcation

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir = fullfile(util.dir.getAnnotation,'bifurcationDiameter');
prop.apicalType = { 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.fixedEnding = {'start','end','exit'}';
end

