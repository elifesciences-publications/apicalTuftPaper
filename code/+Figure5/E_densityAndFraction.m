%% Fig. 5E: Comparison of synaptic composition at the main bifurcation of L5 neurons
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

%% initial Set-up
util.clearAll;
outputFolder = fullfile(util.dir.getFig(5),'E');
util.mkdir(outputFolder);
c = util.plot.getColors();

%% Get skeletons and create variables for densities and inhibitory ratio
skel = apicalTuft('PPC2_l2vsl3vsl5');
skel = skel.sortTreesByName;
cellTypeRatios = skel.applyMethod2ObjectArray({skel},...
    'getSynRatio',[],false,'mapping');
distance2somaRaw = skel.applyMethod2ObjectArray({skel},...
    'getDistanceBWPoints',[],false,'dist2soma');
cellTypeDensity = skel.applyMethod2ObjectArray({skel},...
    'getSynDensityPerType',[],false,'mapping');

%% Create cell arrays used for plotting
inhFraction = cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
inhDensity = cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
excDensity = cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);
distance2soma = distance2somaRaw.Variables;

%% Get the corrected values for L5st group
% Get the correction fraction
axonSwitchFraction = dendrite.synIdentity.loadSwitchFraction;
L5stswitchFraction = axonSwitchFraction.L2{'L5A',:};
L5Atrees = skel.groupingVariable.layer5AApicalDendrite_mapping{1};

% Get Corrected densities/fractions into a table
densityC = skel.getSynDensityPerType(L5Atrees, L5stswitchFraction);
ratioC = skel.getSynRatio(L5Atrees, L5stswitchFraction);
combinedCorrected = join(densityC,ratioC,...
    'Keys','treeIndex');
% Varibales for assigning
variableNames = {'inhFraction','inhDensity','excDensity'};
tableVariableNames = {'Shaft_corrected_ratioC',...
    'Shaft_corrected_densityC','Spine_corrected_densityC'};
% check tree names equality
assert(isequal(combinedCorrected.treeIndex,...
    cellTypeDensity{end,1}{1}.treeIndex));
assert(isequal(combinedCorrected.treeIndex,...
    cellTypeRatios{end,1}{1}.treeIndex));
% Note: Here I use the evalin to correct, the variables above. Not the
% ideal method since it makes the code confusing.
for i = 1:3
    curUncorrected = evalin('base',[variableNames{i},'{end}']);
    curCorrected = combinedCorrected.(tableVariableNames{i});
    % Keep track of fraction/density of synapses before correction for
    % later plotting
    L5stBeforeCorrection.(variableNames{i}) = curUncorrected;
    % Change values to corrected for plotting
    evalin('base',[variableNames{i},'{end} = curCorrected;']);
end

%% Plotting for Figure 5: inhibitoy ratio
x_width = 3;
y_width = 3.8;
colors = c.l2vsl3vsl5;
indices = [1,2,3,1,4];
% inhibitory Ratio
fname = 'E_inhibitoryFraction';
fh = figure('Name',fname);ax = gca;
mkrSize = 10;
noisyXValues = ...
    util.plot.boxPlotRawOverlay(inhFraction,indices,'ylim',1,'boxWidth',0.5496,...
    'color',colors,'tickSize',mkrSize);
% Make sure order of corrected and uncorrected values match
% Plot the uncorrected L5A values as grey crosses and connect them with a
% line
L5sthorizontal = noisyXValues{end}(1,:)';
dendrite.L5.plotBeforeCorrection(L5stBeforeCorrection.inhFraction,inhFraction{end},...
    L5sthorizontal)
% Cosmetics & save
xticks(1:max(indices));
yticks(0:0.2:1)
xlim([0.5, max(indices)+.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg']);

%% Plotting for Figure 5: synapse density
util.mkdir(outputFolder)
x_width = 2;
y_width = 2.2;
colors = [repmat({c.exccolor},1,5);repmat({c.inhcolor},1,5)];
allDensitites = [excDensity';inhDensity'];
% Merge L2 with L2MN
densityIndices = 1:10;
densityIndices(7:8) = 1:2;
densityIndices(9:10) = 7:8;
% Density plot
fh = figure;ax = gca;
curXLoc = util.plot.boxPlotRawOverlay(allDensitites(:),densityIndices(:),...
    'ylim',10,'boxWidth',0.5,'color',colors(:),'tickSize',10);

% Get the uncorrected values and concatenate the excitatory and inhibitory
% synapse densities
curXLoc = cat(2,curXLoc{end-1:end})';
thisUnCorrected = [L5stBeforeCorrection.excDensity;...
    L5stBeforeCorrection.inhDensity];

% Add the L5A raw data points
dendrite.L5.plotBeforeCorrection(thisUnCorrected,curXLoc(:,2),curXLoc(:,1))

% Fig props
set(ax,'yscale','log');
yticks([0.1,1,10]);
yticklabels([0.1,1,10]);
xlim([0.5,8.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'E_synapseDensities.svg','off','on');

%% Testing for fraction of inhibitory synapses
% L2 and L2MN are merged for testing as well
mergeGroups = {[1,4]};
curLabels = cellTypeRatios.Properties.RowNames;
% Test for the inhibitory fraction
KWtest.inhFraction = util.stat.KW(inhFraction,curLabels,mergeGroups,...
    fullfile(outputFolder,fname));

% KW test for excitatory and inhibitory synapse density as well
KWtest.Exc = util.stat.KW(excDensity,curLabels,mergeGroups,...
    fullfile(outputFolder,'excDensity'));
KWtest.Inh = util.stat.KW(inhDensity,curLabels,mergeGroups,...
    fullfile(outputFolder,'inhDensity'));
