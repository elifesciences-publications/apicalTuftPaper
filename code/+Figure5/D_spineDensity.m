% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Script to generate boxplots showing differences in the features  between
% L5A and L5B neurons (diameter and spine density)
util.clearAll
returnTable = true;
skel.dense = apicalTuft.getObjects('l2vsl3vsl5',[],returnTable);
synDensity = apicalTuft.applyMethod2ObjectArray...
    (skel.dense,'getSynDensityPerType',[], false, ...
    'mapping');
% Combine L5A and LPtA data
[synDensity] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synDensity);
synDensity = synDensity{[3,5],:};

%% Get spine density ready for plotting

% Spine density is equal to exc syn density without correction
spineDensitySep = cellfun(@(x) x.Spine,synDensity,'UniformOutput',false);
% Merge distalAD with the bifurcation area results
for i = 1:2
spineDensityForPlot{i} = cat(1, spineDensitySep{i,:});
end

%% Plot Diameter/spineDensity
x_width = 2;
y_width = 3.8;
boxWidths = 0.4655;
outputFolder = fullfile(util.dir.getFig(5),...
    'L5L5AComparison');util.mkdir(outputFolder)
curColors = {l5color,l5Acolor};
region = {'mainBifurcation','distalAD'};

fname = ['L5L5AComparison_spineDensity'];
fh = figure('Name',fname);ax = gca;

util.plot.boxPlotRawOverlay(spineDensityForPlot(:),1:2,...
    'boxWidth',boxWidths,'color',curColors(:),'tickSize',10);
xlim([0.5,2.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on');

%% Testing for the text: combine distalAD and main bifurcaiton

util.stat.ranksum(cat(1,forPlot.spineDensity{1}),cat(1,forPlot.spineDensity{2}),...
    fullfile(outputFolder,'spineDensityCombined'));
util.copyfiles2fileServer

%% Save the AD diameter and spine density information
spineDensityBifurcation = forPlotSep.spineDensity(:,1)';

matfolder = fullfile(util.dir.getAnnotation,'matfiles',...
    'L5stL5ttFeatures');
util.mkdir (matfolder)
save(fullfile(matfolder,'spineDensityAtMainBifurcation.mat'),...
    'spineDensityBifurcation');
