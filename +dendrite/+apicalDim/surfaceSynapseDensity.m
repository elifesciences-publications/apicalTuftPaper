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
[results.l235] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(results.l235);
%% Plot the diameter of different cell types
% Groups:
% Smaller datasets: S1, V2, PPC and ACC: L2 vs. Deep
% PPC2 dataset: L2 vs L3 vs L5 vs L5A
% LPtA dataset: L2 vs L3 vs L5 vs L5A
x_width=[2, 2.6];
y_width=[3.8, 3.8];
boxWidths=[.4655,0.708];
mkrSize=10;
variables={'apicalDiameter','inhSurfDensity',...
    'excSurfDensity'};
datasets={'All'};
curColors={l2color,dlcolor};
curResultStruct=...
    dendrite.util.rearrangeArrayForPlot(results.bifur,datasets,variables);

% Diameter comparison
fname='Small_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,1:2,...
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);
xlim([0.5,2.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');


% Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'Small','Densities'},'_');
fhDense = figure('Name',fname);axDense=gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = repmat({exccolor,inhcolor},1,2);

util.plot.boxPlotRawOverlay(curSynSurfaceDensity(:),1:4,...
    'boxWidth',boxWidths(2),'color',curColors,'tickSize',mkrSize);

% Set density plot properties
set(axDense,'XTickLabel',[],'XLim',[0.5 4.5],...
    'YLim',[0.001,1],'YScale','log');
util.plot.cosmeticsSave...
    (fhDense,axDense,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'off','on');
% Testing for the diameter
for v=1:3
util.stat.ranksum(curResultStruct.(variables{v}){1},...
    curResultStruct.(variables{v}){2},...
    fullfile(outputFolder,[fname,'_',variables{v}]));
end

%% Comparison of L2, L3 and L5 at the main bifurcation: PPC2 dataset
% Correct
x_width=[2.6, 2.6];
y_width=[3.8, 3.8];
boxWidths=[0.708,0.708];

cellTypes2Include=1:5;
layerOrigin={'mainBifurcation','distalAD'};
variables={'apicalDiameter','inhSurfDensity',...
    'excSurfDensity'};
l235esults=...
    dendrite.util.rearrangeArrayForPlot(results.l235,...
    layerOrigin,variables);
curResultStruct=l235esults.mainBifurcation;
curLabels=results.l235.Properties.RowNames(cellTypes2Include);
curColors={l2color;l3color;l5color;l2MNcolor;l5Acolor};

% Diameter comparison
fname='PPC2_mainBifurcation_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.apicalDiameter,[1,2,3,1,4],...
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
% Merge L@ and L2MN cells for the KW test
mergeGroups={[1,4]};
util.stat.KW(curResultStruct.apicalDiameter,curLabels,mergeGroups);

% Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'CellType_mainBifurcation','Densities'},'_');
fhDense = figure('Name',fname);axDense=gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = [repmat({exccolor},1,5);repmat({inhcolor},1,5)];
indices=dendrite.l2vsl3vsl5.mergeL2Indices().density;

util.plot.boxPlotRawOverlay(curSynSurfaceDensity(:),indices,...
    'boxWidth',boxWidths(2),'color',curColors(:),'tickSize',mkrSize);
% Set density plot properties
set(axDense,'XTickLabel',[],'XLim',[0.5 8.5],...
   'YLim',[0.01,2],'YScale','log');
util.plot.cosmeticsSave...
    (fhDense,axDense,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'off','on');
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
    'boxWidth',boxWidths(1),'color',curColors,'tickSize',mkrSize);
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
util.stat.KW(curResultStruct.apicalDiameter,curLabels);


% Excitatory/Inhibitory surface Density boxplot
fname = strjoin({'CellType_DistalAD','Densities'},'_');
fhDense = figure('Name',fname);axDense=gca;

curSynSurfaceDensity = [curResultStruct.excSurfDensity;...
    curResultStruct.inhSurfDensity];
curColors = [repmat({exccolor},1,4);repmat({inhcolor},1,4)];

util.plot.boxPlotRawOverlay(curSynSurfaceDensity(:),...
    1:8,...
    'boxWidth',boxWidths(2),'color',curColors(:),'tickSize',mkrSize);
% Set density plot properties
set(axDense,'XTickLabel',[],'XLim',[0.5 8.5],...
   'YLim',[0.01,1],'YScale','log');
util.plot.cosmeticsSave...
    (fhDense,axDense,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'off','on');