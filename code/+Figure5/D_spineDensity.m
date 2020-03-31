%% Fig. 5D: Comaprison of spine density between L5tt and L5st neurons
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

util.clearAll
c = util.plot.getColors();
returnTable = true;
%% Get skeleton and spine density (equivalent to the "Spine"/Excitatory
% synapse group)
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
spineDensityForPlot = cell(1,2);
for i = 1:2
    spineDensityForPlot{i} = cat(1, spineDensitySep{i,:});
end

%% Plot spineDensity
x_width = 2;
y_width = 3.8;
boxWidths = 0.4655;
outputFolder = fullfile(util.dir.getFig(5),...
    'D');util.mkdir(outputFolder)
curColors = {c.l5color,c.l5Acolor};
region = {'mainBifurcation','distalAD'};

fname = ['L5SubtypeComparison_spineDensity'];
fh = figure('Name',fname);ax = gca;

util.plot.boxPlotRawOverlay(spineDensityForPlot(:),1:2,...
    'boxWidth',boxWidths,'color',curColors(:),'tickSize',10);
xlim([0.5,2.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on');

%% Testing for the text: combine distalAD and main bifurcaiton
util.stat.ranksum(spineDensityForPlot{1},spineDensityForPlot{2},...
    fullfile(outputFolder,'spineDensityCombined'));

%% Save the AD diameter and spine density information
spineDensityBifurcation = forPlotSep.spineDensity(:,1)';
matfolder = fullfile(util.dir.getMatfile,...
    'L5stL5ttFeatures');
util.mkdir(matfolder)
save(fullfile(matfolder,'spineDensityAtMainBifurcation.mat'),...
    'spineDensityBifurcation');
