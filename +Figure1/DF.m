% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getFig1,'DF');
util.mkdir(outputFolder);
%% Get synapse densities per shaft path length
apTuft=apicalTuft.getObjects('bifurcation');
Density=apicalTuft.applyMethod2ObjectArray...
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
util.stat.ranksum(shaftDensity{1,5},shaftDensity{2,5});
util.stat.ranksum(spineDensity{1,5},spineDensity{2,5});
filename2Save=fullfile(outputFolder,'raksumTestResults.txt');
util.stat.ranksum.synapseDensity(shaftDensity,spineDensity,...
    Density.Properties.VariableNames,filename2Save);

%% Plot part: Figure 1E
% Parameters
x_width=12;
y_width=10;
spineXLocation=num2cell([1:2.5:25]');
shaftXLocation=num2cell([2:2.5:25]');
fh=figure;ax=gca;
% The densities
densities=[spineDensity(:),shaftDensity(:)];
densities=densities(:);
% Horizontal locations
horizontalLocation=[spineXLocation,shaftXLocation];
horizontalLocation=horizontalLocation(:);
% the colors
colors=repmat([{[1,0,0]},{[0,0,1]}],10,1);
colors=colors(:);
% plotting
util.plot.boxPlotRawOverlay(densities,horizontalLocation,...
    'boxWidth',.85,'color',colors);
% Additional options
set(ax,'xtick',[],'XLim',[0.2 25.3],...
   'YTick',[0.04,0.4,4],'YLim',[0.025 4.5],'YScale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.svg','off','on');
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
x_width=6.6;
y_width=5.6;
spineXLocation=num2cell([1:2.5:5]');
shaftXLocation=num2cell([2:2.5:5.5]');
fh=figure;ax=gca;
% Horizontal locations
horizontalLocation=[spineXLocation,shaftXLocation];
horizontalLocation=horizontalLocation(:);
% the colors
colors=repmat([{[1,0,0]},{[0,0,1]}],2,1);
colors=colors(:);
% plotting
util.plot.boxPlotRawOverlay(densities_Agg,horizontalLocation,...
    'boxWidth',0.7496,'color',colors);
% Additional options
set(ax,'xtick',[],'XLim',[0.2 5.3],...
   'YTick',[0.04,0.4,4],'YTickLabel',[],'YLim',[0.025 4.5],'YScale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities_Agg.svg',...
    'off','on');
% results separated by dataset:
% Parameters
x_width=6.6;
y_width=5.6;
spineXLocation=num2cell([1:2.5:20]');
shaftXLocation=num2cell([2:2.5:20]');
fh=figure;ax=gca;
% Horizontal locations
horizontalLocation=[spineXLocation,shaftXLocation];
horizontalLocation=horizontalLocation(:);
% the colors
colors=repmat([{[1,0,0]},{[0,0,1]}],8,1);
colors=colors(:);
% plotting
util.plot.boxPlotRawOverlay(densities_Sep,horizontalLocation,...
    'boxWidth',.85,'color',colors);
% Additional options
set(ax,'xtick',[],'XLim',[0.2 20.3],...
   'YTick',[0.04,0.4,4],'YTickLabel',[],'YLim',[0.025 4.5],'YScale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities_Sep.svg',...
    'off','on');