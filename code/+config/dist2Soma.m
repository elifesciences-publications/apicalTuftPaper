function [prop] = dist2Soma()
%dist2Soma 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir = fullfile(util.dir.getAnnotation,'dist2Soma');
prop.apicalType = { 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.fixedEnding = {'start','end','exit','soma'}';
end

