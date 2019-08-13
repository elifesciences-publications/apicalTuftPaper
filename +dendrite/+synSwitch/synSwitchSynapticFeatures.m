%% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getFig3,'correctionforAxonSwitching');
util.mkdir(outputFolder)
m=matfile(fullfile(util.dir.getAnnotation,'matfiles',...
    'axonSwitchFraction.mat'));
axonSwitchFraction=m.axonSwitchFraction;

%% Get the skeletons for dense reconstruction
skel.bifur=apicalTuft.getObjects('bifurcation');
skel.l235=apicalTuft.getObjects('l2vsl3vsl5');

%% Get the uncorrected synapse density and ratios
synDensity.uc.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur,'getSynDensityPerType',[], false);
synDensity.uc.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235,'getSynDensityPerType',[], false, ...
    'mapping');
synRatio.uc.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur,'getSynRatio',[], false);
synRatio.uc.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235,'getSynRatio',[], false, ...
    'mapping');
synDensity.uc=dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synDensity.uc);
synRatio.uc=dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synRatio.uc);

%% Datasets within L2: small datasets containing the main bifurcation 
% annotations in L2
[results]=...
    dendrite.synSwitch.getCorrected.smallDatasets(skel,synRatio,synDensity);
%% Small L2 datasets: Plotting correlation between corrected and not corrected
% synapse density and ratios
x_width=12;
y_width=10;
curResults=results.bifur.Aggregate;

% Inhibitory ratio
fh=figure;ax=gca;
util.plot.correlation({curResults{1}.Shaft_Ratio,...
    curResults{2}.Shaft_Ratio},{l2color,dlcolor});
limits=[0,1];
set(ax,'XLim',limits,'YLim',limits);
plot([limits(1),limits(2)],[limits(1),limits(2)],'Color','k');
daspect([1,1,1]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'L2Datasets_synRatios.svg',...
    'on','on');

% Inhibitory/Excitatory Density
fh=figure;ax=gca;
util.plot.correlation({curResults{1}.Shaft_Density,...
    curResults{2}.Shaft_Density,curResults{1}.Spine_Density,...
    curResults{2}.Spine_Density},{l2color,dlcolor,l2color,dlcolor},...
    {'.','.','x','x'});
limits=[0,5];
set(ax,'XLim',limits,'YLim',limits);
plot([limits(1),limits(2)],[limits(1),limits(2)],'Color','k');
daspect([1,1,1]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'L2Datasets_synDensities.svg',...
    'on','on');
%% Datasets with defined L2, L3 and L5 cell types plus L5A and L2MN
% These datasets provide data from both main bifurcation and distal Tuft
% of ADs
[results]=...
    dendrite.synSwitch.getCorrected.LargeDatasets(skel,...
    synRatio,synDensity,results);

%% Plotting
%% Small L2 datasets: Plotting correlation between corrected and not corrected
% synapse density and ratios
x_width=12;
y_width=10;
curResults=results.l235;

% Inhibitory ratio
fh=figure;ax=gca;
util.plot.correlation({curResults{1}.Shaft_Ratio,...
    curResults{2}.Shaft_Ratio},util.plot.getColors().l2vsl3vsl5');
limits=[0,1];
set(ax,'XLim',limits,'YLim',limits);
plot([limits(1),limits(2)],[limits(1),limits(2)],'Color','k');
daspect([1,1,1]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'L2Datasets_synRatios.svg',...
    'on','on');

% Inhibitory/Excitatory Density
fh=figure;ax=gca;
util.plot.correlation({curResults{1}.Shaft_Density,...
    curResults{2}.Shaft_Density,curResults{1}.Spine_Density,...
    curResults{2}.Spine_Density},{l2color,dlcolor,l2color,dlcolor},...
    {'.','.','x','x'});
limits=[0,5];
set(ax,'XLim',limits,'YLim',limits);
plot([limits(1),limits(2)],[limits(1),limits(2)],'Color','k');
daspect([1,1,1]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'L2Datasets_synDensities.svg',...
    'on','on');