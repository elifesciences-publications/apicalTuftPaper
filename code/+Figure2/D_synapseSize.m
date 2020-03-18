% Fig. 2D: The size of synaptic area for synapses onto shaft
% (putative inhibiotory) and spine (putative excitatory) synapses of apical
% dendrites from L2 and Deep (L3/5) pyramidal neurons

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll
outputDir = fullfile(util.dir.getFig(2),'D');
util.mkdir(outputDir)
c = util.plot.getColors();
colors = repmat([{c.l2color};{c.dlcolor}],2,1);

%% Get the synapse sizes
synapseSizes = dendrite.synSize.synapseSize;
aggregateSynapseSizes = synapseSizes(:,:,5);
aggregateSynapseSizes = aggregateSynapseSizes(:);
%% Plot the figure panel
fh = figure; ax = gca;
hold on
util.plot.boxPlotRawOverlay(aggregateSynapseSizes,1:4,...
    'boxWidth',0.708,'color',colors,'tickSize',10)
% Cosmetics
xlim([0.5,4.5]);
ylim([0,2]);
yticklabels([]);
yticks(0:0.5:2);

statTestFile = fullfile(outputDir,'ranksumTestSynSize.txt');
util.stat.ranksum.synSize(synapseSizes,{'Spine','Shaft'},statTestFile);
% Cosmetics
util.plot.cosmeticsSave(fh,ax,2.6,3.8,outputDir,'synSizeComparison.svg',...
    'off','on');
%% write data to excel
synSizeTable = cell2table(synapseSizes(:,:,5),'VariableNames',...
    {'Spine','Shaft'},'RowNames',{'layer2AD','deepLayerAD'});
excelFileName = fullfile(util.dir.getExcelDir(2),'Fig2D.xlsx');
util.table.write(synSizeTable, excelFileName);
