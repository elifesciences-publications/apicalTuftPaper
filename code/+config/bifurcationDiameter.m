function [prop] = bifurcationDiameter()
% bifurcation Diameter: took out the part from soma to the start of main bifurcation annotaitons 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=fullfile(util.dir.getAnnotation,'bifurcationDiameter');
prop.apicalType={ 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.fixedEnding={'start','end','exit'}';
end

