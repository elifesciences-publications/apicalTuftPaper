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
% Note to self: There are minor differences between the path length of the backbone
% of the spine annotations since certain corrections were done on the
% diameter measurement. Therefore the numbers might not completely match.
% biggest difference: (3.93 um in ACC DLaxon10)
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
    'excSurfDensity','inhDensity',{'apicalDiameter','inhDensity'},...
    {'apicalDiameter','excDensity'}};
datasets = {'All'};
curColors = {c.l2color,c.dlcolor};
smallDataset_resultStruct = ...
    dendrite.util.rearrangeArrayForPlot(results.bifur,datasets,variables);

% Diameter comparison
fname = 'Small_apicalDiameter';
fh = figure('Name',fname);ax = gca;
util.plot.boxPlotRawOverlay(smallDataset_resultStruct.apicalDiameter,1:2,...
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);
xlim([0.5,2.5])
ylim([0,4])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');

%% Comparison numbers for text
AdditionalL2Inhibition_path = (mean(smallDataset_resultStruct.inhDensity{1}) / ...
    mean(smallDataset_resultStruct.inhDensity{2})-1)*100;
AdditionalL2Inhibition_surface = (mean(smallDataset_resultStruct.inhSurfDensity{1}) / ...
    mean(smallDataset_resultStruct.inhSurfDensity{2})-1)*100;

disp(['AdditionalL2Inhibition_path (percent): ',...
    num2str(AdditionalL2Inhibition_path)])
disp(['AdditionalL2Inhibition_surface (percent): ',...
    num2str(AdditionalL2Inhibition_surface)])
%% Small datasets: Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'Small','Densities'},'_');
fhDense = figure('Name',fname);axDense = gca;

curSynSurfaceDensity = [smallDataset_resultStruct.excSurfDensity;...
    smallDataset_resultStruct.inhSurfDensity];
curColors = repmat({c.exccolor,c.inhcolor},1,2);

% Testing for the diameter
for v = 1:3
    util.stat.ranksum(smallDataset_resultStruct.(variables{v}){1},...
        smallDataset_resultStruct.(variables{v}){2},...
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
%% Write excel sheet
excelTable = struct2table...
    (structfun(@(x) x',smallDataset_resultStruct,'UniformOutput',false)...
    ,'RowNames',{'L2', 'DL'});
% linear density not necessary to write
excelTable(:,4:end) = [];
excelFileName = fullfile(util.dir.getExcelDir(2),'Fig2FG.xlsx');
util.table.write(excelTable,excelFileName);

%% Correlation between diameter and synapse density (normalized to path length)
x_width = [2.6, 2.6];
y_width = [3.8, 3.8];
boxWidths = [0.708,0.708];

cellTypes2Include = 1:5;
layerOrigin = {'mainBifurcation','distalAD'};
l235results = ...
    dendrite.util.rearrangeArrayForPlot(results.l235,...
    layerOrigin,variables);
curLabels = results.l235.Properties.RowNames(cellTypes2Include);

%% Important: Figure 2 Supplement 1:Plot aggregate correlation

% Get the synapse density (per path length) and the average apical dendrite
% diameter and use it to plot the correlation
synapseType = {'inh','exc'};
densityRelation.inh = ...
    [l235results.distalAD.apicalDiameter_inhDensity([1,2,3,5]),...
    l235results.mainBifurcation.apicalDiameter_inhDensity,...
    smallDataset_resultStruct.apicalDiameter_inhDensity];
densityRelation.exc = ...
    [l235results.distalAD.apicalDiameter_excDensity([1,2,3,5]),...
    l235results.mainBifurcation.apicalDiameter_excDensity,...
    smallDataset_resultStruct.apicalDiameter_excDensity];

% Get the color combination
curColors = {c.l2color;c.l3color;c.l5color;c.l5Acolor;...% distal AD
    c.l2color;c.l3color;c.l5color;c.l2MNcolor;c.l5Acolor;...% main bifurcation PPC2
    c.l2color;c.dlcolor};% main bifurcation S1, V2, PPC, ACC

% Maximum values for inhibitory and excitatory synapse densities
ylimit = [1,6];

% Plot loop
for i = 1:2
    fname = ['allDataCombined_',synapseType{i}];
    fh = figure('Name',fname);ax = gca;
    textName = fullfile(outputFolder,[fname,'.txt']);
    util.plot.correlation(densityRelation.(synapseType{i}),...
        curColors,[],10,textName);
    xlim([0,3.5]);ylim([0,ylimit(i)]);
    util.plot.addLinearFit(densityRelation.(synapseType{i}),[],...
        textName);
    util.plot.cosmeticsSave...
        (fh,ax,3,3,outputFolder,...
        [fname,'.svg'],'on','on');
end