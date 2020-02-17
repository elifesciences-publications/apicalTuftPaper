function [prop] = apicalDiameter()
%apicalDiameter 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=fullfile(util.dir.getAnnotation,'apicalDiameter');
prop.apicalType={ 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.fixedEnding={'start','end','exit'}';
end

