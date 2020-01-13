function [prop] = wholeApical()
%wholeApical properties used by the apical tuft class for the dense
%synapse input annotation of apical dendrites completely throughout the
%dataset (high resolution part for LPtA)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=util.dir.getWholeApical;
prop.apicalType={ 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.syn={'Shaft','spineSingleInnervated','spineDoubleInnervated','spineNeck'}';
prop.synExclusion='unsureSynapse';
prop.synGroups={{1,3,4}'}';
prop.synLabel={'Shaft','Spine'}';
prop.fixedEnding={'start','end','exit'}';
end
