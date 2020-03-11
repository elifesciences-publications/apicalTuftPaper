% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Get the dense reconstruction and diameter measurements both for small and
% larger datasets used to annotate the differences between l2, l3 and l5
% pyramdial neurons
util.clearAll;
outputFolder = fullfile(util.dir.getFig(2),...
    'synapseDensityPerUnitSurface');
util.mkdir(outputFolder)

returnTable = true;
skel.bifur.dense = apicalTuft.getObjects('bifurcation',[],returnTable);
skel.bifur.dim = apicalTuft.getObjects('bifurcationDiameter',[],returnTable);
skel.l235.dense = apicalTuft.getObjects('l2vsl3vsl5',[],returnTable);
skel.l235.dim = apicalTuft.getObjects('l2vsl3vsl5Diameter',[],returnTable);

%% First step get all the synapse counts from dense annotations
synCount.bifur = apicalTuft.applyMethod2ObjectArray...
    (skel.bifur.dense,'getSynCount',[], false);
synCount.l235 = apicalTuft.applyMethod2ObjectArray...
    (skel.l235.dense,'getSynCount',[], false, ...
    'mapping');

%% Second: get the pathlength from diameter measurements
pL.bifur = apicalTuft.applyMethod2ObjectArray...
    (skel.bifur.dim,'pathLength',[], false);
pL.l235 = apicalTuft.applyMethod2ObjectArray...
    (skel.l235.dim,'pathLength',[], false, ...
    'mapping');

%% Third: Get the dendrite diameters
dim.bifur = apicalTuft.applyMethod2ObjectArray...
    (skel.bifur.dim,'getApicalDiameter',[], false);
dim.l235 = apicalTuft.applyMethod2ObjectArray...
    (skel.l235.dim,'getApicalDiameter',[], false, ...
    'mapping');

%% Combine all data into a common table
results = ...
    dendrite.apicalDim.surfaceDensity.generateDiameterTable ...
    (synCount, dim, pL, skel.l235.dense);
% Combine the annotations from LPtA (L2-5) and PPC2 (L5A)
% to create the distal group
[results.l235] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(results.l235);
%% Plot the diameter of small datasets

x_width = [2, 2.6];
y_width = [1.9, 3.8];
boxWidths = [.4655,0.708];
mkrSize = 10;
variables = {'apicalDiameter','inhSurfDensity',...
    'excSurfDensity',...
    {'apicalDiameter','inhDensity'},{'apicalDiameter','excDensity'}};
datasets = {'All'};
curColors = {l2color,dlcolor};
curResultStruct = ...
    dendrite.util.rearrangeArrayForPlot(results.bifur,datasets,variables);

% Diameter comparison
fname = 'Small_apicalDiameter';
fh = figure('Name',fname);ax = gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,1:2,...
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);
xlim([0.5,2.5])
ylim([0,4])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
%% Also plot correlation between path length synapse density and diameter
curVars = ...
    cellfun(@ (x) strjoin(x,'_'),  variables(4:5),'UniformOutput',false);
ylims = [0,1;0,4.5];
cor.xWidth = 2;cor.yWidth = 2;
for i = 1:2
    fname = ['SmallDataset',curVars{i}];
    fh = figure('Name',fname);ax = gca;
    fullNameForText = fullfile(outputFolder,[fname,'.txt']);
    util.plot.correlation(curResultStruct.(curVars{i}),...
        {l2color,dlcolor},[],10,fullNameForText);
    xlim([1,3.5]);ylim(ylims(i,:))
    util.plot.addLinearFit(curResultStruct.(curVars{i}),true,...
        fullNameForText);
    util.plot.cosmeticsSave...
        (fh,ax,cor.xWidth,cor.yWidth,outputFolder,...
        [fname,'.svg'],'on','on');
end
%% Small datasets: Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'Small','Densities'},'_');
fhDense = figure('Name',fname);axDense = gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = repmat({exccolor,inhcolor},1,2);
% Testing for the diameter
for v = 1:3
    util.stat.ranksum(curResultStruct.(variables{v}){1},...
        curResultStruct.(variables{v}){2},...
        fullfile(outputFolder,[fname,'_',variables{v}]));
end
util.plot.boxPlotRawOverlay(curSynSurfaceDensity(:),1:4,...
    'boxWidth',boxWidths(2),'color',curColors,'tickSize',mkrSize);

% Set density plot properties
set(axDense,'XTickLabel',[],'XLim',[0.5 4.5],...
    'YLim',[0.001,1],'YScale','log');
util.plot.cosmeticsSave...
    (fhDense,axDense,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'off','on');


%% Comparison of L2, L3 and L5 at the main bifurcation: PPC2 dataset
% Correct
x_width = [2.6, 2.6];
y_width = [3.8, 3.8];
boxWidths = [0.708,0.708];

cellTypes2Include = 1:5;
layerOrigin = {'mainBifurcation','distalAD'};
variables = {'apicalDiameter','inhSurfDensity',...
    'excSurfDensity',{'apicalDiameter','inhDensity'},...
    {'apicalDiameter','excDensity'}};
l235results = ...
    dendrite.util.rearrangeArrayForPlot(results.l235,...
    layerOrigin,variables);
curResultStruct = l235results.mainBifurcation;
curLabels = results.l235.Properties.RowNames(cellTypes2Include);
curColors = {l2color;l3color;l5color;l2MNcolor;l5Acolor};

%% Diameter comparison, main bifurcation PPC2
fname = 'PPC2_mainBifurcation_apicalDiameter';
fh = figure('Name',fname);ax = gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,[1,2,3,1,4],...
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);

% Merge L2 and L2MN cells for the KW test
mergeGroups = {[1,4]};
util.stat.KW(curResultStruct.apicalDiameter,curLabels,mergeGroups,...
    fullfile(outputFolder,fname));

util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
%% Also plot correlation between path length synapse density and diameter
curVars = ...
    cellfun(@ (x) strjoin(x,'_'),  variables(4:5),'UniformOutput',false);
ylims = [0,0.8;0,6];
cor.xWidth = 2.5;cor.yWidth = 2.5;
for i = 1:2
    fname = ['mainbifurcation_cellTypes',curVars{i}];
    fh = figure('Name',fname);ax = gca;
    textName = fullfile(outputFolder,[fname,'.txt']);
    util.plot.correlation(curResultStruct.(curVars{i}),...
        curColors,[],10,textName);
    %xlim([0,2.5]);ylim(ylims(i,:))
    util.plot.addLinearFit(curResultStruct.(curVars{i}),[],...
        textName);
    util.plot.cosmeticsSave...
        (fh,ax,cor.xWidth,cor.yWidth,outputFolder,...
        [fname,'.svg'],'on','on');
end

%% Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'CellType_mainBifurcation','Densities'},'_');
fhDense = figure('Name',fname);axDense = gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = [repmat({exccolor},1,5);repmat({inhcolor},1,5)];
indices = dendrite.l2vsl3vsl5.mergeL2Indices().density;

xLoc = util.plot.boxPlotRawOverlay(curSynSurfaceDensity(:),indices,...
    'boxWidth',boxWidths(2),'color',curColors(:),'tickSize',mkrSize);
% Set density plot properties
set(axDense,'XTickLabel',[],'XLim',[0.5 8.5],...
    'YLim',[0.01,2],'YTick',[0.01,0.1,1],'YTickLabel',[0.01,0.1,1],...
    'YScale','log');

dendrite.apicalDim.surfaceDensity.addL5AUncorrected(xLoc, results,...
    'mainBifurcation');

% Merge L2 and L2MN cells for the KW test
mergeGroups = {[1,4]};
synTypeLabel = {'inhSurfDensity','excSurfDensity'};
for i = 1:2
    util.stat.KW(curResultStruct.(synTypeLabel{i}),curLabels,mergeGroups,...
        fullfile(outputFolder,[fname,'_',synTypeLabel{i}]));
end

util.plot.cosmeticsSave...
    (fhDense,axDense,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'off','on');

%% Comparison of different cell types distal innervation:
% LPtA and PPC2 datasets
cellTypes2Include = [1,2,3,5];
curResultStruct = l235results.distalAD;
% Remove empty L2 group
curResultStruct = structfun(@(x) x(cellTypes2Include),curResultStruct,...
    'UniformOutput',false);

curColors = {l2color;l3color;l5color;l5Acolor};
curLabels = results.l235.Properties.RowNames(cellTypes2Include);
% Diameter comparison
fname = 'LPtAPPC2_distalAD_apicalDiameter';
fh = figure('Name',fname);ax = gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,1:length(cellTypes2Include),...
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);
% KW test
util.stat.KW(curResultStruct.apicalDiameter,curLabels,[],...
    fullfile(outputFolder,fname));
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
%% Also plot correlation between path length synapse density and diameter
curVars = ...
    cellfun(@ (x) strjoin(x,'_'),  variables(4:5),'UniformOutput',false);
ylims = [0,0.4;0,4.5];
cor.xWidth = 2.5;cor.yWidth = 2.5;
for i = 1:2
    fname = ['distalAD_cellTypes',curVars{i}];
    fh = figure('Name',fname);ax = gca;
    fullNameForText = fullfile(outputFolder,[fname,'.txt']);
    util.plot.correlation(curResultStruct.(curVars{i}),...
        curColors,[],10,fullNameForText);
    %xlim([0,2.5]);ylim(ylims(i,:))
    util.plot.addLinearFit(curResultStruct.(curVars{i}),[],fullNameForText);
    util.plot.cosmeticsSave...
        (fh,ax,cor.xWidth,cor.yWidth,outputFolder,...
        [fname,'.svg'],'on','on');
end
%% Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'CellType_DistalAD','Densities'},'_');
fhDense = figure('Name',fname);axDense = gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = [repmat({exccolor},1,4);repmat({inhcolor},1,4)];

xLoc = util.plot.boxPlotRawOverlay(curSynSurfaceDensity(:),...
    1:8,...
    'boxWidth',boxWidths(2),'color',curColors(:),'tickSize',mkrSize);
% Set density plot properties
set(axDense,'XTickLabel',[],'XLim',[0.5 8.5],...
    'YLim',[0.01,1],'YTick',[0.01,0.1,1],'YTickLabel',[0.01,0.1,1],...
    'YScale','log');

% Add L5st uncorrected
dendrite.apicalDim.surfaceDensity.addL5AUncorrected(xLoc, results,...
    'distalAD');

% Merge L2 and L2MN cells for the KW test
synTypeLabel = {'inhSurfDensity','excSurfDensity'};
for i = 1:2
    util.stat.KW(curResultStruct.(synTypeLabel{i}),curLabels,[],...
        fullfile(outputFolder,[fname,'_',synTypeLabel{i}]));
end
util.plot.cosmeticsSave...
    (fhDense,axDense,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'off','on');

%% Plot aggregate correlation
smallDatasetResults =  dendrite.util.rearrangeArrayForPlot...
    (results.bifur,datasets,variables);
curVars = {'inh','exc'};
densityRelation.inh = [l235results.distalAD.apicalDiameter_inhDensity([1,2,3,5]),...
    l235results.mainBifurcation.apicalDiameter_inhDensity,...
    smallDatasetResults.apicalDiameter_inhDensity];
densityRelation.exc = [l235results.distalAD.apicalDiameter_excDensity([1,2,3,5]),...
    l235results.mainBifurcation.apicalDiameter_excDensity,...
    smallDatasetResults.apicalDiameter_excDensity];
curColors = {l2color;l3color;l5color;l5Acolor;l2color;l3color;l5color;...
    l2MNcolor;l5Acolor;l2color;dlcolor};
ylimit = [1,6];
for i = 1:2
    fname = ['allDataCombined_',curVars{i}];
    fh = figure('Name',fname);ax = gca;
    textName = fullfile(outputFolder,[fname,'.txt']);
    util.plot.correlation(densityRelation.(curVars{i}),...
        curColors,[],10,textName);
    xlim([0,3.5]);ylim([0,ylimit(i)]);
    util.plot.addLinearFit(densityRelation.(curVars{i}),[],...
        textName);
    util.plot.cosmeticsSave...
        (fh,ax,3,3,outputFolder,...
        [fname,'.svg'],'on','on');
end