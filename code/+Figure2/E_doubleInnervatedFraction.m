% Plot the ratio of double innervated spines
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder = fullfile(util.dir.getFig(1),'J');
util.mkdir(outputFolder);
%% Get Ratio of inhibitory counts

apTuft = apicalTuft.getObjects('bifurcation');
% Change the synapse grouping from config.bifurcation to put inhibitory
% spines (spine neck and spine head) into a separate Group
apTuft = apicalTuft.groupInhibitorySpines(apTuft);
synCount = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');

% Reason for using the double spines/spines ratio is that we annotate both
% of the synapses in the case of inhibitory spines therefore the "Spine"
% group contains all spines and the "InhSpines" group contains only the
% double innervated group
fractionOfDoubleSpines = cellfun(@(x) x.InhSpines./x.Spine,...
    synCount(:,5).Variables,'UniformOutput',false);
%% Plot
fh = figure; ax = gca;
hold on
util.plot.boxPlotRawOverlay(fractionOfDoubleSpines,[{1},{2}],...
    'boxWidth',.4655,'color',[{l2color},{dlcolor}]);

% Cosmetics
xlim([0.5,2.5]);
ylim([0,0.25]);
set(gca, 'YTickLabel',[]);
util.plot.cosmeticsSave(fh,ax,2,1.9,...
    outputFolder,util.addDateToFileName('DoubleSpineFraction.svg'));
%% Write result table to matfile
matFileName = fullfile(outputFolder,'Figure1_DoubleSpineRatio.mat');
save(util.addDateToFileName( matFileName),'synCount');
%% statistical testing
statTestFile = fullfile(outputFolder ,...
    util.addDateToFileName('ranksumTestDoubleSpineFraction.txt'));
util.stat.ranksum.doubleSpine(fractionOfDoubleSpines,statTestFile);

