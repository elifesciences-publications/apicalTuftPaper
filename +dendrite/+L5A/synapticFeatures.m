% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Script to generate boxplots showing differences in the features  between
% L5A and L5B neurons (diameter and spine density) 
util.clearAll
returnTable=true;
skel.dense=apicalTuft.getObjects('l2vsl3vsl5',[],returnTable);
skel.dim=apicalTuft.getObjects('l2vsl3vsl5Diameter',[],returnTable);

synCount=apicalTuft.applyMethod2ObjectArray...
    (skel.dense,'getSynCount',[], false, ...
    'mapping');
dim=apicalTuft.applyMethod2ObjectArray...
    (skel.dim,'getApicalDiameter',[], false, ...
    'mapping');
diameters=cell(1,2)
synapseDensities=cell(1,2)
for i=1:2
end