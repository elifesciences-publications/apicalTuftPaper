% Fig. 2FG, Figure 2, Figure Supplement. 1: Get the dense reconstruction 
% and diameter measurements both for small and larger datasets used to 
% annotate the differences between l2, l3 and l5 pyramdial neurons

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder = fullfile(util.dir.getFig(2),...
    'FG');
util.mkdir(outputFolder);
c = util.plot.getColors();

%% Get the apical tuft objects
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
curColors = {c.l2color,c.dlcolor};
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

%% Small datasets: Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'Small','Densities'},'_');
fhDense = figure('Name',fname);axDense = gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = repmat({c.exccolor,c.inhcolor},1,2);
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

%% Important: Figure 2 Supplement 1:Plot aggregate correlation
smallDatasetResults =  dendrite.util.rearrangeArrayForPlot...
    (results.bifur,datasets,variables);
curVars = {'inh','exc'};
densityRelation.inh = [l235results.distalAD.apicalDiameter_inhDensity([1,2,3,5]),...
    l235results.mainBifurcation.apicalDiameter_inhDensity,...
    smallDatasetResults.apicalDiameter_inhDensity];
densityRelation.exc = [l235results.distalAD.apicalDiameter_excDensity([1,2,3,5]),...
    l235results.mainBifurcation.apicalDiameter_excDensity,...
    smallDatasetResults.apicalDiameter_excDensity];
curColors = {c.l2color;c.l3color;c.l5color;c.l5Acolor;c.l2color;c.l3color;c.l5color;...
    c.l2MNcolor;c.l5Acolor;c.l2color;c.dlcolor};
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