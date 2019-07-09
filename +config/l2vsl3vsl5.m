function [prop] = l2vsl3vsl5()
% Bifurcations properties used by the apical tuft class for the dense
% synapse input annotation 10um around the main bifurcation of apical
% dendrites (Figure 1 mainly)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
prop.outputDir=fullfile(util.dir.getAnnotation,'l2vsl3vsl5');
prop.apicalType={ 'layer2ApicalDendrite_mapping',...
    'layer3ApicalDendrite_mapping','layer5ApicalDendrite_mapping',...
    'layer2ApicalDendrite_dist2soma',...
    'layer3ApicalDendrite_dist2soma','layer5ApicalDendrite_dist2soma'};
prop.syn={'Shaft','spineSingleInnervated',...
    'spineDoubleInnervated','spineNeck'}';
prop.synExclusion='unsureSynapse';
prop.synGroups={{1,3,4}'}';
prop.synLabel={'Shaft','Spine'}';
prop.fixedEnding={'start','end','exit','soma','bifurcation','dead end'}';
prop.legacyGrouping=false;

end