% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Get the dense reconstruction and diameter measurements both for small and
% larger datasets used to annotate the differences between l2, l3 and l5
% pyramdial neurons
util.clearAll;
outputFolder = fullfile(util.dir.getFig3,...
    'synapseDensityPerUnitSurface');
util.mkdir(outputFolder)

returnTable=true;
skel.bifur.dense=apicalTuft.getObjects('bifurcation',[],returnTable);
skel.bifur.dim=apicalTuft.getObjects('bifurcationDiameter',[],returnTable);
skel.l235.dense=apicalTuft.getObjects('l2vsl3vsl5',[],returnTable);
skel.l235.dim=apicalTuft.getObjects('l2vsl3vsl5Diameter',[],returnTable);

%% First step get all the synapse counts from dense annotations
synCount.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur.dense,'getSynCount',[], false);
synCount.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235.dense,'getSynCount',[], false, ...
    'mapping');

%% Second: get the pathlength from diameter measurements
pL.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur.dim,'pathLength',[], false);
pL.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235.dim,'pathLength',[], false, ...
    'mapping');

%% Third: Get the dendrite diameters
dim.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur.dim,'getApicalDiameter',[], false);
dim.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235.dim,'getApicalDiameter',[], false, ...
    'mapping');

%% Combine all data into a common table
results=dendrite.apicalDim.surfaceDensity. ...
    generateDiameterTable(synCount,dim,pL);
% Combine the annotations from LPtA (L2-5) and PPC2 (L5A) 
% to create the distal group
[results] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(results);
%% Plot the diameter of different cell types
% Groups:
% Smaller datasets: S1, V2, PPC and ACC: L2 vs. Deep
% PPC2 dataset: L2 vs L3 vs L5 vs L5A
% LPtA dataset: L2 vs L3 vs L5 vs L5A
x_width=[2, 2, 2];
y_width=[4, 2, 2];
mkrSize=15;
variables={'apicalDiameter',{'inhSurfDensity','inhDensity'},...
    {'excSurfDensity','excDensity'}};
datasets={'All'};
curColors={l2color,dlcolor};
curResultStruct=...
    dendrite.util.rearrangeArrayForPlot(results.bifur,datasets,variables);

% Diameter comparison
fname='Small_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,1:2,...
    'boxWidth',0.5,'color',curColors,'tickSize',mkrSize);
xlim([0.5,2.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
pvalDiameterSmall=...
    util.stat.ranksum(curResultStruct.apicalDiameter{1},...
    curResultStruct.apicalDiameter{2});
vars=fieldnames(curResultStruct);
% Excitatory/Inhibitory surface vs pathlength synapse densities
for i=2:3
fname=strjoin({'Small',vars{i}},'_');
fhEx=figure('Name',fname);axEx=gca;
util.plot.correlation(curResultStruct.(vars{i}),curColors,[],20);
util.plot.addLinearFit(curResultStruct.(vars{i}));
util.plot.cosmeticsSave...
    (fhEx,axEx,x_width(i),y_width(i),outputFolder,...
    [fname,'.svg'],'on','on');
end

%% Comparison of L2, L3 and L5 at the main bifurcation: PPC2 dataset
cellTypes2Include=1:5;
layerOrigin={'mainBifurcation','distalAD'};
variables={'apicalDiameter',{'inhSurfDensity','inhDensity'},...
    {'excSurfDensity','excDensity'}};
l235esults=...
    dendrite.util.rearrangeArrayForPlot(results.l235,...
    layerOrigin,variables);
curResultStruct=l235esults.mainBifurcation;
curLabels=results.l235.Properties.RowNames(cellTypes2Include);
curColors={l2color;l3color;l5color;l2MNcolor;l5Acolor};
mkrSize=15;

% Diameter comparison
fname='PPC2_mainBifurcation_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,[1,2,3,1,4],...
    'boxWidth',0.5,'color',curColors,'tickSize',mkrSize);
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
% Merge L@ and L2MN cells for the KW test
mergeGroups={[1,4]};
util.stat.KW(curResultStruct.apicalDiameter,curLabels,mergeGroups);

% Excitatory/Inhibitory surface vs pathlength synapse densities
vars=fieldnames(curResultStruct);
for i=2:3
fname=strjoin({'CellType_mainBifurcation',vars{i}},'_');
fh=figure('Name',fname);ax=gca;
util.plot.correlation(curResultStruct.(vars{i}),curColors);
util.plot.addLinearFit(curResultStruct.(vars{i}));
util.plot.cosmeticsSave...
    (fh,ax,x_width(i),y_width(i),outputFolder,...
    [fname,'.svg'],'on','on');
end

%% Comparison of different cell types distal innervation: 
% LPtA and PPC2 datasets
cellTypes2Include=[1,2,3,5];
curResultStruct=l235esults.distalAD;
% Remove empty L2 group
curResultStruct=structfun(@(x) x(cellTypes2Include),curResultStruct,...
    'UniformOutput',false);

curColors={l2color;l3color;l5color;l5Acolor};
curLabels=results.l235.Properties.RowNames(cellTypes2Include);
% Diameter comparison
fname='LPtAPPC2_distalAD_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,1:length(cellTypes2Include),...
    'boxWidth',0.5,'color',curColors,'tickSize',mkrSize);
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
util.stat.KW(curResultStruct.apicalDiameter,curLabels);

% Excitatory/Inhibitory surface vs pathlength synapse densities
vars=fieldnames(curResultStruct);
for i=2:3
fname=strjoin({'CellType_DistalAD',vars{i}},'_');
fh=figure('Name',fname);ax=gca;
util.plot.correlation(curResultStruct.(vars{i}),curColors);
util.plot.addLinearFit(curResultStruct.(vars{i}));
util.plot.cosmeticsSave...
    (fh,ax,x_width(i),y_width(i),outputFolder,...
    [fname,'.svg'],'on','on');
end