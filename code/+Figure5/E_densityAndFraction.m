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
shaftRatio = cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
shaftDensity = cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
spineDensity = cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);
distance2soma = distance2somaRaw.Variables;

%% Set the values of the L5st group to the corrected values and 
% also keep the uncorrected values for later plotting 

% TODO: remove this time consuming function with a call to getSynCount with
% the correction fraction like the following:
% curCorrected = ...
% skel{1,d}.getSynCount(L5Atrees,L5stswitchFraction{d});
% % Load axon switching fraction
% axonSwitchFraction = dendrite.synIdentity.loadSwitchFraction;
% 
% % Mimick the shape of the L5A entries in the other variables (LPtA empty entry)
% L5stswitchFraction = ...
%     {axonSwitchFraction.L2{'L5A',:},{},...
%     axonSwitchFraction.L1{'layer5AApicalDendriteSeeded',:}};

results = dendrite.synIdentity.getCorrected.getAllRatioAndDensityResult;
% Keep only the main bifurcation results from L5A (L5st) group
resultsL5A = results.l235{end,:}{1};
% varibales for assigning
variableNames = {'shaftRatio','shaftDensity','spineDensity'};
tableVariableNames = {'Shaft_Ratio','Shaft_Density','Spine_Density'};
for i = 1:3
    curUncorrected = evalin('base',[variableNames{i},'{end}']);
    curCorrected = resultsL5A.(tableVariableNames{i})(:,2);
    assert(isequal(curUncorrected,resultsL5A.(tableVariableNames{i})(:,1)));
    % save uncorrected (raw values for plotting later)
    l5ARawData.(variableNames{i}) = curUncorrected;
    % Change values to corrected for plotting
    evalin('base',[variableNames{i},'{end} = curCorrected;']);
end

%% Plotting for Figure 5: inhibitoy ratio
util.mkdir (outputFolder)
util.setColors
x_width = 3;
y_width = 3.8;
colors = util.plot.getColors().l2vsl3vsl5;
indices = [1,2,3,1,4];
% inhibitory Ratio
fname = 'ShaftFraction_mainBifurcation';
fh = figure('Name',fname);ax = gca;
mkrSize = 10;
noisyXValues = ...
    util.plot.boxPlotRawOverlay(shaftRatio,indices,'ylim',1,'boxWidth',0.5496,...
    'color',colors,'tickSize',mkrSize);
% Make sure order of corrected and uncorrected values match
L5Ahorizontal = noisyXValues{end}(1,:)';
assert( isequal(noisyXValues{end}(2,:)', resultsL5A.Shaft_Ratio(:,2)) );

% Plot the uncorrected L5A values as grey crosses and connect them with a
% line
dendrite.L5.plotBeforeCorrection(l5ARawData.shaftRatio,shaftRatio{end},...
    L5Ahorizontal)

xticks(1:max(indices));
yticks(0:0.2:1)
xlim([0.5, max(indices)+.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg']);

%% Do Kruskall-Wallis test for the shaft Ratios
% Merge L2 and L2MN
mergeGroups = {[1,4]};
curLabels = cellTypeRatios.Properties.RowNames;
testResult = util.stat.KW(shaftRatio,curLabels,mergeGroups,...
    fullfile(outputFolder,fname));

% Text: Ranksum comparison L2, L2MN, L5st, L5tt
util.stat.ranksum(shaftRatio{1},shaftRatio{4},fullfile(outputFolder,...
    'L2L2MNComparison_ShaftRation'));
util.stat.ranksum(shaftRatio{3},shaftRatio{5},fullfile(outputFolder,...
    'L5ttL5stComparison_ShaftRation'));

% KW test for ecitatory and inhibitory synapse density as well
testResult.Exc = util.stat.KW(spineDensity,curLabels,mergeGroups,...
    fullfile(outputFolder,'excDensity'));
testResult.Inh = util.stat.KW(shaftDensity,curLabels,mergeGroups,...
    fullfile(outputFolder,'inhDensity'));

%% Plotting for Figure 5: synapse density
util.mkdir(outputFolder)
x_width = 2;
y_width = 2.2;
colors = [repmat({exccolor},1,5);repmat({inhcolor},1,5)];
allDensitites = [spineDensity';shaftDensity'];
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
thisUnCorrected = [l5ARawData.spineDensity;l5ARawData.shaftDensity];

% Add the L5A raw data points
dendrite.L5.plotBeforeCorrection(thisUnCorrected,curXLoc(:,2),curXLoc(:,1))

% Fig props
set(ax,'yscale','log');
yticks([0.1,1,10]);
yticklabels([0.1,1,10]);
xlim([0.5,8.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.svg','off','on');