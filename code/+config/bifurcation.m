function [prop] = bifurcation()
% Bifurcations properties used by the apical tuft class for the dense
% synapse input annotation 10um around the main bifurcation of apical
% dendrites (Figure 1 mainly)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=util.dir.getBifurcation;
prop.apicalType={ 'layer2ApicalDendrite','deepLayerApicalDendrite'};
prop.syn={'Shaft','spineSingleInnervated','spineDoubleInnervated','spineNeck'}';
prop.synExclusion='unsureSynapse';
prop.synGroups={{1,3,4}'}';
prop.synLabel={'Shaft','Spine'}';
prop.fixedEnding={'start','end','exit'}';
end

