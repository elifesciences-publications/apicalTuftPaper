%% Set up
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
skel = apicalTuft('PPC2_l2vsl3vsl5');
outputFolder = fullfile(util.dir.getFig(5),...
    'somaDepthRanges');util.mkdir(outputFolder);
c = util.plot.getColors();

%% Get tree Indices of L5 and L5A neurons
dist2somaTreeIdx = skel.groupingVariable(:,...
    contains(skel.groupingVariable.Properties.VariableNames,'dist2soma'));
% Get depth of all somata for plotting and methods text
somaDepthAll = dendrite.L5.somaDepth.getSkeleton...
    (skel,dist2somaTreeIdx.Variables);
% Make separate L5 variable: 3: L5tt, 5: L5st
somaDepth_L5 = somaDepthAll([3,5]);
depthRanges = ...
    cellfun(@util.math.returnMinMax,somaDepthAll,'UniformOutput',false);
allRangeArray = cat(1,depthRanges{:});
allRangeT = array2table(allRangeArray,'VariableNames',...
    {'MinDepth','MaxDepth'},'RowNames',...
    dist2somaTreeIdx.Properties.VariableNames);
outputFolderRanges = fullfile(util.dir.getFig(5),...
    'somaDepthRanges');util.mkdir(outputFolderRanges);
writetable(allRangeT,fullfile(outputFolderRanges,'somaDepthRanges_PPC2.xlsx'),...
    'WriteRowNames',true);

%% Plot their histgrams
curColors ={c.l5color,c.l5Acolor};
curFeatName = 'histogram_somaDepthL5';
fh = figure ('Name',curFeatName);ax = gca;
x_width = 2;
y_width = 1;
hold on
for cellT = 1:2
    histogram(somaDepth_L5{cellT},'BinEdges',520:20:640,...
        'DisplayStyle','stairs','EdgeColor', curColors{cellT});
end
hold off
xlim([520,640]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [curFeatName,'_histogram.svg'],'on','off');

%% Plot box plot of comparison between somatic depth of L5tt and L5st cells
% relative to pial surface
x_width = 2;
y_width = 1.9;

fname = 'somaDepthRelPia_L5vsL5A';
fh = figure('Name',fname);ax = gca;
curColors = {c.l5color,c.l5Acolor};
util.plot.boxPlotRawOverlay(somaDepth_L5,1:2,...
    'boxWidth',0.4655,'color',curColors);
ylim([500,650]);
set(ax, 'YDir','reverse')
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on')

%% Statistical testing
util.stat.ranksum(somaDepth_L5{1},somaDepth_L5{2},...
    fullfile(outputFolder,'somaDepthL5tt_L5st'));

%% Save the soma depth information
matfolder = fullfile(util.dir.getMatfile,...
    'L5stL5ttFeatures');
util.mkdir (matfolder)
save(fullfile(matfolder,'somaDepth.mat'),'somaDepth_L5');
