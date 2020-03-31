%% Fig. 7BC: The density of synapses in the distal tuft of apical dendrites
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
%% Setup
util.clearAll;
outputFolder = fullfile(util.dir.getFig(7),'distalvsMain');
util.mkdir(outputFolder);
c = util.plot.getColors;

%% Get annotations and extract density/ratios of putative inhibitory and excitatory synapses
distalSkel = apicalTuft('LPtA_l2vsl3vsl5');
distalSkel = distalSkel.sortTreesByName;
L5ASkel = apicalTuft('PPC2L5ADistal_l2vsl3vsl5');
L5ASkel = L5ASkel.sortTreesByName;

distal = dendrite.l2vsl3vsl5.getRatioDensities(distalSkel);
distalL5A = dendrite.l2vsl3vsl5.getRatioDensities(L5ASkel);
% Merge L5A results from the PPC2 dataset with the results fronm the L5A
% dataset
vars = fieldnames(distal);
for i = 1:length(vars)
    distal.(vars{i}) = [distal.(vars{i});distalL5A.(vars{i})];
end

%% Set the values of the L5st group to the corrected values and 
% also keep the uncorrected values for later plotting 
results = dendrite.synIdentity.getCorrected.getAllRatioAndDensityResult;
% Keep only the distalAD results from L5A (L5st) group
curResultsL5A = results.l235{end,:}{2};
% varibales for assigning
variableNames = {'shaftRatio','shaftDensity','spineDensity'};
tableVariableNames = {'Shaft_Ratio','Shaft_Density','Spine_Density'};
for i = 1:3
    curUncorrected = distal.(variableNames{i}){end};
    curCorrected = curResultsL5A.(tableVariableNames{i})(:,2);
    assert(isequal(curUncorrected,curResultsL5A.(tableVariableNames{i})(:,1)));
    % save uncorrected (raw values for plotting later)
    l5ARawData.(variableNames{i}) = curUncorrected;
    % Change values to corrected for plotting
    distal.(variableNames{i}){end} = curCorrected;
end

%% Plot inhibitory Ratios
x_width = 3;
y_width = 3.8;
colors = {l2color,l3color,l5color,l5Acolor};
fname = 'ShaftFraction';
fh = figure('Name',fname);ax = gca;
noisyXValues = ...
    util.plot.boxPlotRawOverlay(distal.shaftRatio,1:4,'ylim',1,'boxWidth',0.5496,...
'color',colors,'tickSize',15);

% Make sure order of corrected and uncorrected values match
L5Ahorizontal = noisyXValues{end}(1,:)';
assert( isequal(noisyXValues{end}(2,:)', curResultsL5A.Shaft_Ratio(:,2)) );

% Plot the uncorrected L5A values as grey crosses and connect them with a
% line
dendrite.L5.plotUncorrected(l5ARawData.shaftRatio,distal.shaftRatio{end},...
    L5Ahorizontal);

xticklabels([]);
yticks(0:0.2:1);
xlim([0.5, 4.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg']);

%% Do Kruskall-Wallis test for the shaft Ratios
% Merge L2 and L2MN
cellTypes = {'L2','L3','L5B','L5A'};
testResult = util.stat.KW(distal.shaftRatio,cellTypes, ...
    [],fullfile(outputFolder,fname));
% Text: Ranksum comparison L2, L2MN, L5st, L5tt

util.stat.ranksum(distal.shaftRatio{3},distal.shaftRatio{4},fullfile(outputFolder,...
    'Distal_L5ttL5stComparison_ShaftRation'))

%% Also do the densities
x_width = 2;
y_width = 2.2;
colors = [repmat({exccolor},1,4);repmat({inhcolor},1,4)];

allDensitites = [distal.spineDensity';distal.shaftDensity'];
fh = figure;ax = gca;
curXLoc = ...
    util.plot.boxPlotRawOverlay(allDensitites(:),1:8,'ylim',10,'boxWidth',0.5,...
'color',colors(:),'tickSize',10);
set(ax,'yscale','log');
yticks([0.1,1,10]);
yticklabels([0.1,1,10]);
xticklabels([]);

% Get the uncorrected values and concatenate the excitatory and inhibitory
% synapse densities
curXLoc = cat(2,curXLoc{end-1:end})';
thisUnCorrected = [l5ARawData.spineDensity;l5ARawData.shaftDensity];

% Add the L5A raw data points
dendrite.L5.plotUncorrected(thisUnCorrected,curXLoc(:,2),curXLoc(:,1));

xlim([0.5,8.5])
ylim([0.05,10])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.svg','off','on');
%% Kruskall Wallis test for densities
cellTypes = {'L2','L3','L5B','L5A'};
testResult_inhDensity = util.stat.KW(distal.shaftDensity,cellTypes, ...
    [],fullfile(outputFolder,'InhDensity'));
testResult_excDensity = util.stat.KW(distal.spineDensity,cellTypes, ...
    [],fullfile(outputFolder,'excDensity'));

%% Do single cell type between regions comparison:
skel = apicalTuft('PPC2_l2vsl3vsl5');
skel = skel.sortTreesByName;
cellTypeRatios = skel.applyMethod2ObjectArray({skel},...
    'getSynRatio',[],false,'mapping');
cellTypeDensity = skel.applyMethod2ObjectArray({skel},...
    'getSynDensityPerType',[],false,'mapping');

bifur.shaftRatio = cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
bifur.shaftDensity = cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
bifur.spineDensity = cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);

% Get the layer 2 numbers form main bifurcation annotations and add them to
% the other layer 2 results
bifur = dendrite.l2vsl3vsl5.concatenateSmallDatasetL2(bifur);
% Also combine the L2MN group with the L2 group for the comparison
f = fieldnames(bifur);
for i = 1:length(f)
    bifur.(f{i}){1} = [bifur.(f{i}){1};bifur.(f{i}){4}];
    bifur.(f{i})(4) = [];
end
% Only for L5st: switch to corrected value as in the distalAD case
% previously
curResultsL5A = results.l235{end,:}{1};
% Table variable names in results
tableVariableNames = {'Shaft_Ratio','Shaft_Density','Spine_Density'};
for i = 1:length(f)
    curUncorrected = bifur.(f{i}){end};
    curCorrected = curResultsL5A.(tableVariableNames{i})(:,2);
    assert(isequal(curUncorrected,curResultsL5A.(tableVariableNames{i})(:,1)));
    % Change values to corrected for plotting
    bifur.(f{i}){end} = curCorrected;
end
% Test for main bifurcation vs distal tuft results
% Also get the mean and SEMs for summary plot
for celltype = 1:length(cellTypes)
    disp([cellTypes{celltype},': main bifurcation vs. distal tuft'])
    testResultsRatios.(cellTypes{celltype}) = ...
        util.stat.ranksum....
        (bifur.shaftRatio{celltype},distal.shaftRatio{celltype},...
        fullfile (outputFolder, ['ranksumBifurAndDistal_',...
        cellTypes{celltype},'.txt']));
end

%% create the error bar for summary plot
fh = figure;ax = gca;
colors = {l2color,l3color,l5color,l5Acolor};
hold on
loc = -([-0.15:0.1:0.15]./8);
for celltype = 1:length(cellTypes)
    curField = cellTypes{celltype};
    curColor = colors{celltype};
    errorbar([2,1],testResultsRatios.(curField).mean,...
        testResultsRatios.(curField).sem,....
        'Color',curColor);
end
xlim([0.85, 2.15]);
ylim([0,0.4]);
xticks(1:2);
yticks(0:0.1:0.6)
xticklabels([]);
x_width = 3.5;
y_width = 2.5;
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'summaryPlot.svg','off','on');
%% layer 5 excitatory shaft, spine synapse density and inhibitory fraction
util.stat.ranksum(bifur.spineDensity{3},distal.spineDensity{3});
util.stat.ranksum(bifur.shaftDensity{3},distal.shaftDensity{3});
disp(testResultsRatios.L5B)
%% layer 2 excitatory shaft, spine synapse density and inhibitory fraction
util.stat.ranksum(bifur.spineDensity{1},distal.spineDensity{1});
util.stat.ranksum(bifur.shaftDensity{1},distal.shaftDensity{1});
disp(testResultsRatios.L2)
%% layer 3
util.stat.ranksum(bifur.shaftRatio{2},distal.shaftRatio{2});
util.stat.ranksum(bifur.shaftRatio{2},bifur.shaftRatio{3});
util.stat.ranksum(distal.shaftRatio{2},distal.shaftRatio{1});
%% Distal: Get the mean values for text
Means = cellfun(@(x)round(mean(x).*100,2),distal.shaftRatio);
Sems = cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),distal.shaftRatio);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)
%% Bifurcation: Get the mean values for text
Means = cellfun(@(x)round(mean(x).*100,2),bifur.shaftRatio);
Sems = cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),bifur.shaftRatio);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)

%% Get total synapse numbers for the text
L5ACount = L5ASkel.getSynCount;

% Get trees with the mappings
mappingG = contains(distalSkel.groupingVariable.Properties.VariableNames,...
    'mapping');
curIndices = cat(1,distalSkel.groupingVariable{:,mappingG}{:});
L235BCount = distalSkel.getSynCount(curIndices);

Total= sum(L235BCount{:,2:end},1) + sum(L5ACount{:,2:end},1);