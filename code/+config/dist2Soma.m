function [prop] = dist2Soma()
% dist2Soma: setting for distance 2 soma annotation of smaller datasets.
% Note: Contains the dist2soma measurements for both bifurcation and whole
% apical tracings

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir = fullfile(util.dir.getAnnotation,'dist2Soma');
prop.apicalType = { 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.fixedEnding = {'start','end','exit','soma'}';
end

