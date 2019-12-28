% Clear a1ll
util.clearAll;
%% Load skeleton an pia surface
l1 = util.plot.loadl1;
skel = apicalTuft('PPC2_l2vsl3vsl5');
%% Get tree Indices of L5 and L5A neurons
dist2somaTreeIdx = skel.groupingVariable(:,...
    contains(skel.groupingVariable.Properties.VariableNames,'dist2soma'));
% Get tree Indices of L5tt and L5st neurons
tr_L5L5A = [dist2somaTreeIdx.layer5ApicalDendrite_dist2soma,...
    dist2somaTreeIdx.layer5AApicalDendrite_dist2soma];
somaDepth = cell(size(tr_L5L5A));
% Get their distance to pia
for cellT = 1:length(tr_L5L5A)
    curTr = tr_L5L5A{cellT};
    curNodes = skel.getNodesWithComment('soma',curTr,'insensitive');
    assert(length(curNodes)==length(curTr));
    curSomaCoords = skel.getNodes(curTr,curNodes);
    % convert to NM for plotting and distance to pia measurement and make
    % the first dimension XYZ
    curSomaCoordsInNM = round(curSomaCoords.*skel.scale)';
    % Measurement of distance to pia
    somaDepth{cellT}=...
        (dendrite.L5A.somaDepth.dist2plane...
        (l1.fitSurfaceNM,curSomaCoordsInNM)./1000)+145;
end
%% Also get depth of all somata for methods text
somaDepthAll = dendrite.L5A.somaDepth.getSkeleton...
    (skel,dist2somaTreeIdx.Variables);
depthRanges = ...
    cellfun(@util.math.returnMinMax,somaDepthAll,'UniformOutput',false);
allRangeArray = cat(1,depthRanges{:});
allRangeT = array2table(allRangeArray,'VariableNames',...
    {'MinDepth','MaxDepth'},'RowNames',...
    dist2somaTreeIdx.Properties.VariableNames);
outputFolderRanges=fullfile(util.dir.getFig5,...
    'somaDepthRanges');util.mkdir(outputFolderRanges);
writetable(allRangeT,fullfile(outputFolderRanges,'somaDepthRanges_PPC2.txt'),...
    'WriteRowNames',true);
util.copyfiles2fileServer;
%% Plot their histgrams
outputFolder=fullfile(util.dir.getFig5,...
    'somaDepthL5ttL5st');util.mkdir(outputFolder);
curColors ={l5color,l5Acolor};
curFeatName = 'histogram_somaDepthL5';
fh = figure ('Name',curFeatName);ax = gca;
x_width=2;
y_width=1;
hold on
for c=1:2
    histogram(somaDepth{c},'BinEdges',520:20:640,...
        'DisplayStyle','stairs','EdgeColor', curColors{c});
end
hold off
xlim([520,640]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [curFeatName,'_histogram.svg'],'on','off');

%% Plot box plot of comparison between somatic depth of L5tt and L5st cells
% relative to pial surface

x_width=2;
y_width=1.9;

fname='somaDepthRelPia_L5vsL5A';
fh=figure('Name',fname);ax=gca;
util.setColors;
curColors={l5color,l5Acolor};
util.plot.boxPlotRawOverlay(somaDepth,1:2,...
    'boxWidth',0.4655,'color',curColors);
ylim([500,650]);
set(ax, 'YDir','reverse')
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on')

%% Statistical testing
util.stat.ranksum(somaDepth{1},somaDepth{2},...
    fullfile(outputFolder,'somaDepthL5tt_L5st'));
%% Plot correlation between soma depth and the synaptic features
% Get corrected shaft ratio for L5tt and uncorrected shaft ratio for
% first row is uncorrected (L5tt) vs second row of each results is
% corrected (L5st)
xWidth=2; yWidth=2;
curVars={'Shaft_Ratio','Shaft_Density','Spine_Density'};
[fh,ax] = dendrite.L5A.plotCorrelationWithSynDensity(somaDepth,outputFolder);
for i=1:3
    fname=['CorrelationL5_SomaDepth_',curVars{i}];
    xlim(ax{i},[500,650]);
    set(ax{i},'YDir','normal','XDir','normal')
    util.plot.cosmeticsSave...
        (fh{i},ax{i},xWidth,yWidth,outputFolder,...
        [fname,'.svg'],'on','on');
end
%% Save the soma depth information
matfolder = fullfile(util.dir.getAnnotation,'matfiles',...
    'L5stL5ttFeatures');
util.mkdir (matfolder)
save(fullfile(matfolder,'somaDepth.mat'),'somaDepth');
