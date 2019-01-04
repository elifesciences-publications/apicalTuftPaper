% Get all the synapse sizes
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll
synapseSizes= dendrite.synSize.synapseSize;
%%Initial set-up
outputDir=fullfile(util.dir.getFig1,'I');
util.mkdir(outputDir)

aggregateSynapseSizes=synapseSizes(:,:,5);
aggregateSynapseSizes=aggregateSynapseSizes(:);
colors=repmat([{l2color};{dlcolor}],2,1);
%% Plot
fh = figure; ax = gca;
hold on
util.plot.boxPlotRawOverlay(aggregateSynapseSizes,num2cell(1:4),...
    'boxWidth',.746,'color',colors)
% Cosmetics
xlim([0.5,4.5]);
ylim([0,2]);
yticklabels([]);
yticks(0:0.5:2);

statTestFile=fullfile(outputDir,'ranksumTestSynSize.txt');
util.stat.ranksum.synSize(synapseSizes,{'Spine','Shaft'},statTestFile);
% Cosmetics
util.plot.cosmeticsSave(fh,ax,5.2,4.6,outputDir,'synSizeComparison.svg')

