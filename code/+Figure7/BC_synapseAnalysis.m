%% Fig. 7BC: The density of synapses in the distal tuft of apical dendrites
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
%% Setup
util.clearAll;
outputFolder = fullfile(util.dir.getFig(7),'BC');
util.mkdir(outputFolder);
c = util.plot.getColors;

%% Get annotations and extract density/ratios of putative inhibitory and excitatory synapses
distalSkel = apicalTuft('LPtA_l2vsl3vsl5');
distalSkel = distalSkel.sortTreesByName;
L5st_Skel = apicalTuft('PPC2L5ADistal_l2vsl3vsl5');
L5st_Skel = L5st_Skel.sortTreesByName;

%% Get densities
[distal,withTreeNames.frac,withTreeNames.density,resultsForExcel] = ...
    dendrite.l2vsl3vsl5.getRatioDensities(distalSkel);
% Also get the tree names for checking
[distalL5st, L5stwithTreeNames.frac, L5stwithTreeNames.density] ...
    = dendrite.l2vsl3vsl5.getRatioDensities(L5st_Skel);
[distalL5st, L5stBeforeCorrection, L5stForExcel] = ...
    dendrite.l2vsl3vsl5.correctL5st_fordistal...
    (L5st_Skel,distalL5st,L5stwithTreeNames, 'L1');
% Merge L5st results from the PPC-2 dataset with the results fronm the L5A
% dataset
vars = fieldnames(distal);
for i = 1:length(vars)
    distal.(vars{i}) = [distal.(vars{i});distalL5st.(vars{i})];
end

%% Fig. 7B: Plot inhibitory Ratios
x_width = 3;
y_width = 3.8;
colorsCellType = {c.l2color,c.l3color,c.l5color,c.l5Acolor};
fname = 'inhFraction';
fh = figure('Name',fname);ax = gca;
noisyXValues = ...
    util.plot.boxPlotRawOverlay(distal.inhFraction,1:4,'ylim',1,'boxWidth',0.5496,...
    'color',colorsCellType,'tickSize',15);

% Make sure order of corrected and uncorrected values match
L5sthorizontal = noisyXValues{end}(1,:)';
% Plot the uncorrected L5A values as grey crosses and connect them with a
% line
dendrite.L5.plotBeforeCorrection(L5stBeforeCorrection.inhFraction,...
    distal.inhFraction{end},L5sthorizontal);
% Cosmetics and save
xticklabels([]);
yticks(0:0.2:1);
xlim([0.5, 4.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,['B_',fname,'.svg']);

%% Do Kruskall-Wallis test for the shaft Ratios
% Merge L2 and L2MN
cellTypes = {'L2','L3','L5tt','L5st'};
testResult = util.stat.KW(distal.inhFraction,cellTypes, ...
    [],fullfile(outputFolder,fname));
% Text: Ranksum comparison L2, L2MN, L5st, L5tt

util.stat.ranksum(distal.inhFraction{3},distal.inhFraction{4},fullfile(outputFolder,...
    'Distal_L5ttL5stComparison_inhFractionn'));

%% Fig. 7B: Synapse Densities
x_width = 2;
y_width = 2.2;
colorsForDensity = [repmat({c.exccolor},1,4);repmat({c.inhcolor},1,4)];

allDensitites = [distal.excDensity';distal.inhDensity'];
fh = figure;ax = gca;
curXLoc = ...
    util.plot.boxPlotRawOverlay(allDensitites(:),1:8,'ylim',10,'boxWidth',0.5,...
    'color',colorsForDensity(:),'tickSize',10);


% Add the L5st values before correction
curXLoc = cat(2,curXLoc{end-1:end})';
thisUnCorrected = [L5stBeforeCorrection.excDensity;...
    L5stBeforeCorrection.inhDensity];
dendrite.L5.plotBeforeCorrection(thisUnCorrected,curXLoc(:,2),curXLoc(:,1));

% cosmetics and save
xlim([0.5,8.5]);
ylim([0.05,10]);
set(ax,'yscale','log');
yticks([0.1,1,10]);
yticklabels([0.1,1,10]);
xticklabels([]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'B_synapseDensities.svg','off','on');

%% Kruskall Wallis test for densities
cellTypes = {'L2','L3','L5tt','L5st'};
testResult_inhDensity = util.stat.KW(distal.inhDensity,cellTypes, ...
    [],fullfile(outputFolder,'InhDensity'));
testResult_excDensity = util.stat.KW(distal.excDensity,cellTypes, ...
    [],fullfile(outputFolder,'excDensity'));

%% Load main bifurcation results for comparison
skel_bifur = apicalTuft('PPC2_l2vsl3vsl5');
skel_bifur = skel_bifur.sortTreesByName;
withNames_bifur.frac = skel_bifur.applyMethod2ObjectArray({skel_bifur},...
    'getSynRatio',[],false,'mapping');
withNames_bifur.density = skel_bifur.applyMethod2ObjectArray({skel_bifur},...
    'getSynDensityPerType',[],false,'mapping');

bifur.inhFraction = cellfun(@(x) x.Shaft,withNames_bifur.frac.Variables,...
    'UniformOutput',false);
bifur.inhDensity = cellfun(@(x) x.Shaft,withNames_bifur.density.Variables,...
    'UniformOutput',false);
bifur.excDensity = cellfun(@(x) x.Spine,withNames_bifur.density.Variables,...
    'UniformOutput',false);

%% Only for L5st: switch to corrected values
[bifur] = ...
    dendrite.l2vsl3vsl5.correctL5st_fordistal...
    (skel_bifur,bifur,withNames_bifur, 'L2');

%% Get the layer 2 numbers form main bifurcation annotations and add them to
% the other layer 2 results
bifur = dendrite.l2vsl3vsl5.concatenateSmallDatasetL2(bifur);
% Also combine the L2MN group with the L2 group for the comparison
f = fieldnames(bifur);
for i = 1:length(f)
    bifur.(f{i}){1} = [bifur.(f{i}){1};bifur.(f{i}){4}];
    bifur.(f{i})(4) = [];
end

%% Test for the inhibitory fraction difference between main bifurcation
% and distal tuft of each cell type
variableNames = {'inhFraction','inhDensity','excDensity'};
for celltype = 1:length(cellTypes)
    for var = 1:3
        curVar = variableNames{var};
        curFname = fullfile (outputFolder, [cellTypes{celltype},...
            '_MBvsDistalAD_',curVar,'.txt']);
        curDistal = distal.(curVar){celltype};
        curMB = bifur.(curVar){celltype};
        % Test
        testResults.(curVar).(cellTypes{celltype}) = ...
            util.stat.ranksum(curMB,curDistal,curFname);
    end
end

%% Fig. 7C: create the error bar for summary plot
fh = figure;ax = gca;
hold on
loc = -((-0.15:0.1:0.15)./8);
for celltype = 1:length(cellTypes)
    curField = cellTypes{celltype};
    curColor = colorsCellType{celltype};
    errorbar([2,1],testResults.inhFraction.(curField).mean,...
        testResults.inhFraction.(curField).sem,....
        'Color',curColor);
end
% Cosmetics and Save
xlim([0.85, 2.15]);
ylim([0,0.4]);
xticks(1:2);
yticks(0:0.1:0.6)
xticklabels([]);
x_width = 3.5;
y_width = 2.5;
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'C_summaryPlot.svg','off','on');

%% layer 3 vs. L2 and L5tt
L3result.vsL5ttBifur = ...
    util.stat.ranksum(bifur.inhFraction{2},bifur.inhFraction{3});
L3result.vsL2Distal = ...
    util.stat.ranksum(distal.inhFraction{2},distal.inhFraction{1});

%% Distal: Get the mean values for text
Means = cellfun(@(x)round(mean(x).*100,2),distal.inhFraction);
Sems = cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),distal.inhFraction);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)

%% Bifurcation: Get the mean values for text
% Note: L2 mean here contains data from all datasets vs. the separate
% reporting previously
Means = cellfun(@(x)round(mean(x).*100,2),bifur.inhFraction);
Sems = cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),bifur.inhFraction);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)

%% Text: Get total synapse numbers for the text
L5stCount = L5st_Skel.getSynCount;
% Get trees with the mappings
mappingG = contains(distalSkel.groupingVariable.Properties.VariableNames,...
    'mapping');
curIndices = cat(1,distalSkel.groupingVariable{:,mappingG}{:});
L235BCount = distalSkel.getSynCount(curIndices);

Total = sum(L235BCount{:,2:end},1) + sum(L5stCount{:,2:end},1);
disp(['Total number of synapses in distal AD annotations: ', ...
    num2str(sum(Total))]);

%% Write data to excel sheet
resultsForExcel{4,1} = {L5stForExcel};
resultsForExcel.Properties.RowNames = {'L2','L3','L5tt','L5st'};
excelFileName = fullfile(util.dir.getExcelDir(7),'Fig7B.xlsx');
util.table.write(resultsForExcel,excelFileName);