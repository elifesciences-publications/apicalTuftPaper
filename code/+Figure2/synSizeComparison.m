% Get all the synapse sizes
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll
synapseSizes= dendrite.synSize.synapseSize;
%%Initial set-up
outputDir=fullfile(util.dir.getFig(1),'I');
util.mkdir(outputDir)

aggregateSynapseSizes=synapseSizes(:,:,5);
aggregateSynapseSizes=aggregateSynapseSizes(:);
colors=repmat([{l2color};{dlcolor}],2,1);
%% Plot
fh = figure; ax = gca;
hold on
util.plot.boxPlotRawOverlay(aggregateSynapseSizes,1:4,...
    'boxWidth',0.708,'color',colors,'tickSize',10)
% Cosmetics
xlim([0.5,4.5]);
ylim([0,2]);
yticklabels([]);
yticks(0:0.5:2);

statTestFile=fullfile(outputDir,'ranksumTestSynSize.txt');
util.stat.ranksum.synSize(synapseSizes,{'Spine','Shaft'},statTestFile);
% Cosmetics
util.plot.cosmeticsSave(fh,ax,2.6,3.8,outputDir,'synSizeComparison.svg',...
    'off','on')

