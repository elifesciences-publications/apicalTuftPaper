function [prop] = dist2Soma()
%apicalDiameter 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=fullfile(util.dir.getAnnotation,'dist2Soma');
prop.apicalType={ 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.fixedEnding={'start','end','exit','soma'}';
end

