% Fig.1D and Fig.1E: The density of synapses normalized to the path length
% of the shaft of the apical dendrite

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
c = util.plot.getColors;
outputFolder = fullfile(util.dir.getFig(1),'DF');
util.mkdir(outputFolder);
%% Get synapse densities per shaft path length
apTuft = apicalTuft.getObjects('bifurcation');
Density = apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getSynDensityPerType');
shaftDensity=cellfun(@(x) x.Shaft,Density.Variables,...
    'UniformOutput',false);
spineDensity=cellfun(@(x) x.Spine,Density.Variables,...
    'UniformOutput',false);
%% Write result table to excel sheet
matFileName=fullfile(outputFolder,'Figure1_synapseDensity.mat');
save(util.addDateToFileName( matFileName),'Density');
%% Statistic testing (Wilcoxon ranksum test)
% testing the aggregate
util.stat.ranksum(shaftDensity{1,5},shaftDensity{2,5},...
    fullfile(outputFolder,'raksumTestResults_inh_agg'));
util.stat.ranksum(spineDensity{1,5},spineDensity{2,5},...
    fullfile(outputFolder,'raksumTestResults_exc_agg'));
filename2Save=fullfile(outputFolder,'raksumTestResults.txt');
util.stat.ranksum.synapseDensity(shaftDensity,spineDensity,...
    Density.Properties.VariableNames,filename2Save);

%% Separate Aggregate Data 
% The densities
densities_Agg=[spineDensity(:,5),shaftDensity(:,5)];
densities_Agg=densities_Agg(:);
spineDensitySep=spineDensity(:,1:4);
shaftDensitySep=shaftDensity(:,1:4);
densities_Sep=[spineDensitySep(:),shaftDensitySep(:)];
densities_Sep=densities_Sep(:);
% Aggregate plot:
% Parameters
x_width=3.1;
y_width=2.8;
spineXLocation=num2cell([1:2.5:5]');
shaftXLocation=num2cell([2:2.5:5.5]');
fh=figure;ax=gca;
% Horizontal locations
horizontalLocation=[spineXLocation,shaftXLocation];
horizontalLocation=horizontalLocation(:);
% the colors
curColors=repmat([{c.exccolor},{c.inhcolor}],2,1);
curColors=curColors(:);
% plotting
util.plot.boxPlotRawOverlay(densities_Agg,horizontalLocation,...
    'boxWidth',0.75,'color',curColors,'tickSize',10);
% Additional options
set(ax,'XLim',[0.2 5.3],'YLim',[0.025 4.5],...
   'YTick',[0.01,0.1,1],'YScale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensity_DLL2AD_datasetsCombined.svg',...
    'off','on');
%% results separated by dataset:
% Parameters
spineXLocation=num2cell([1:2.5:20]');
shaftXLocation=num2cell([2:2.5:20]');
fh=figure;ax=gca;
% Horizontal locations
horizontalLocation=[spineXLocation,shaftXLocation];
horizontalLocation=horizontalLocation(:);
% the colors
curColors=repmat([{c.exccolor,c.inhcolor}],8,1);
curColors=curColors(:);
% plotting
util.plot.boxPlotRawOverlay(densities_Sep,horizontalLocation,...
    'boxWidth',.85,'color',curColors);
% Additional options
set(ax,'XLim',[0.2 20.3],...
   'YTick',[0.01,0.1,1],'YLim',[0.025 4.5],'YScale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities_Sep.svg',...
    'off','on');