% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getAnnotation,...
    'doubleInnervatedSpines','beforeAnnotation');
util.mkdir(outputFolder);
util.setColors;
%% Get Ratio of inhibitory counts

apTuft=apicalTuft.getObjects('bifurcation');
% Change the synapse grouping from config.bifurcation to put inhibitory
% spines (spine neck and spine head) into a separate Group
apTuft=apicalTuft.removeGroupingBifurcation(apTuft);
% This would be the number of Maximal trees (within each group of apical dendrite)
% chosen and the number of samples per tree
numberOfTrees=5;
numberOfSamplesPerTree=1;
for d=1:length(apTuft)
[apTuftCommented{d},randomSyn{d}]=apTuft{d}.synRandomSample({'SpineHeadDouble','SpineNeck'},...
    numberOfTrees,numberOfSamplesPerTree);
apTuftCommented{d}.write([apTuft{d}.filename,'_doubleInnervationTodo'],outputFolder);
save(fullfile(outputFolder,'treeAndSynapseIdx.mat'),'randomSyn');
end
