function [prop] = toCorrect()
%wholeApical properties used by the apical tuft class for the dense
%synapse input annotation of apical dendrites completely throughout the
%dataset (high resolution part for LPtA)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=util.dir.getWholeApical;
prop.apicalType={ 'layer2','deep'};
prop.syn={'sh','sp','dual','neck'}';
prop.synExclusion='unsure';
prop.synGroups={}';
prop.synLabel=prop.syn;
prop.fixedEnding={'start','end','exit'}';
end
