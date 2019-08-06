% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Get the dense reconstruction and diameter measurements both for small and
% larger datasets used to annotate the differences between l2, l3 and l5
% pyramdial neurons
util.clearAll;
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
results.l235.LPtA{end}=results.l235.PPC2L5ADistal{end};
results.l235=removevars(results.l235,'PPC2L5ADistal');
results.l235.Properties.VariableNames={'mainBifurcation','distalAD'};
%% Plot the diameter of different cell types
% Groups:
% Smaller datasets: S1, V2, PPC and ACC: L2 vs. Deep
% PPC2 dataset: L2 vs L3 vs L5 vs L5A
% LPtA dataset: L2 vs L3 vs L5 vs L5A
x_width=[8.5, 10, 10];
y_width=[10, 10, 10];
util.setColors;
outputFolder=fullfile(util.dir.getFig3,...
    'synapseDensityPerUnitSurface');
util.mkdir(outputFolder)

curResultsTables=results.bifur.Variables;
curColors={l2color,dlcolor};
curResultStruct=...
    dendrite.apicalDim.surfaceDensity.outputForPlot(curResultsTables);

% Diameter comparison
fname='Small_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.diameter,1:2,...
    'boxWidth',0.5,'color',curColors);
xlim([0.5,2.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
pvalDiameterSmall=...
    util.stat.ranksum(curResultStruct.diameter{1},curResultStruct.diameter{2});

% Excitatory surface vs pathlength synapse densities
fname='Small_Excitatory_pathandSurfaceDensity';
fhEx=figure('Name',fname);axEx=gca;
util.plot.correlation(curResultStruct.excDensity,curColors);
util.plot.addLinearFit(curResultStruct.excDensity);
util.plot.cosmeticsSave...
    (fhEx,axEx,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'on','on');
% Same for inhibitory
fname='Small_Inhibitory_pathandSurfaceDensity';
fhInh=figure('Name',fname);axInh=gca;
util.plot.correlation(curResultStruct.inhDensity,curColors);
util.plot.addLinearFit(curResultStruct.inhDensity);
util.plot.cosmeticsSave...
    (fhInh,axInh,x_width(3),y_width(3),outputFolder,...
    [fname,'.svg'],'on','on');

%% Comparison of L2, L3 and L5 at the main bifurcation: PPC2 dataset
cellTypes2Include=1:5;
curResultsTables=results.l235.mainBifurcation;
curResultStruct=...
    dendrite.apicalDim.surfaceDensity.outputForPlot(curResultsTables);
curLabels=results.l235.Properties.RowNames(cellTypes2Include);
% Constants
outputFolder=fullfile(util.dir.getFig3,...
    'synapseDensityPerUnitSurface');
x_width=[8.5, 10, 10];
y_width=[10, 10, 10];
curColors={l2color;l3color;l5color;l2MNcolor;l5Acolor};
% Diameter comparison
fname='PPC2_mainBifurcation_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.diameter,1:length(cellTypes2Include),...
    'boxWidth',0.5,'color',curColors);
xlim([0.5,length(cellTypes2Include)+.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
util.stat.KW(curResultStruct.diameter,curLabels);

% Excitatory surface vs pathlength synapse densities
fname='PPC2_mainBifur_Excitatory_pathandSurfaceDensity';
fhEx=figure('Name',fname);axEx=gca;
util.plot.correlation(curResultStruct.excDensity,curColors);
util.plot.addLinearFit(curResultStruct.excDensity);
util.plot.cosmeticsSave...
    (fhEx,axEx,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'on','on');
% Same for inhibitory
fname='PPC2_mainBifur_Inhibitory_pathandSurfaceDensity';
fhInh=figure('Name',fname);axInh=gca;
util.plot.correlation(curResultStruct.inhDensity,curColors);
util.plot.addLinearFit(curResultStruct.inhDensity);
util.plot.cosmeticsSave...
    (fhInh,axInh,x_width(3),y_width(3),outputFolder,...
    [fname,'.svg'],'on','on');

%% Comparison of different cell types distal innervation: 
% LPtA and PPC2 datasets
cellTypes2Include=[1,2,3,5];
curResultsTables=results.l235.distalAD;
% Remove empty L2 group
curResultsTables=curResultsTables(cellTypes2Include);
curResultStruct=...
    dendrite.apicalDim.surfaceDensity.outputForPlot(curResultsTables);
% Constants
outputFolder=fullfile(util.dir.getFig3,...
    'synapseDensityPerUnitSurface');
x_width=[8.5, 10, 10];
y_width=[10, 10, 10];
curColors={l2color;l3color;l5color;l5Acolor};
curLabels=results.l235.Properties.RowNames(cellTypes2Include);
% Diameter comparison
fname='LPtAPPC2_distalAD_apicalDiameter';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(curResultStruct.diameter,1:length(cellTypes2Include),...
    'boxWidth',0.5,'color',curColors);
xlim([0.5,length(cellTypes2Include)+.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width(1),y_width(1),outputFolder,...
    [fname,'.svg'],'off','on');
util.stat.KW(curResultStruct.diameter,curLabels);

% Excitatory surface vs pathlength synapse densities
fname='LPtAPPC2_distalAD_Excitatory_pathandSurfaceDensity';
fhEx=figure('Name',fname);axEx=gca;
util.plot.correlation(curResultStruct.excDensity,curColors);
util.plot.addLinearFit(curResultStruct.excDensity);
util.plot.cosmeticsSave...
    (fhEx,axEx,x_width(2),y_width(2),outputFolder,...
    [fname,'.svg'],'on','on');
% Same for inhibitory
fname='LPtAPPC2_distalAD_Inhibitory_pathandSurfaceDensity';
fhInh=figure('Name',fname);axInh=gca;
util.plot.correlation(curResultStruct.inhDensity,curColors);
util.plot.addLinearFit(curResultStruct.inhDensity);
util.plot.cosmeticsSave...
    (fhInh,axInh,x_width(3),y_width(3),outputFolder,...
    [fname,'.svg'],'on','on');
