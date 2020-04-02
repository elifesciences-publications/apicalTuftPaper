%% Fig. 6AB: The relationship between synaptic composition and the length of apical dendrite trunk
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

%% Setup
util.clearAll;
outputFolder = fullfile(util.dir.getFig(6), 'AB');
util.mkdir(outputFolder);
c = util.plot.getColors();

%% Load the annotations from PPC-2 dataset
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

%% Add Layer 2 density fractions from S1, V2, PPC, and ACC datasets
% Put current variables into structure bifur
curVariables = {'inhFraction','inhDensity',...
    'excDensity','distance2soma'};
% Create the structure as the input
for i = 1:length(curVariables)
    bifur.(curVariables{i}) = evalin('base',curVariables{i});
end

% Add other L2 results
bifur = dendrite.l2vsl3vsl5.concatenateSmallDatasetL2(bifur);

% Set the variables in the environment to the aggregate results
for i = 1:length(curVariables)
    assignin('base',curVariables{i},...
        bifur.(curVariables{i}))
end

%% Inhibitory Ratio: Correlation and Exponential fit
[fh,ax,exponentialFit.inhFraction] = dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,inhFraction);
% Add L5A uncorrected
dendrite.L5.plotBeforeCorrection(L5stBeforeCorrection.inhFraction,inhFraction{end},...
    distance2soma{end});

% plot exponential with offset
minDist2Soma = min(cell2mat(distance2soma));
modelfun = @(b,x)(b(1)+b(2)*exp(b(3)*x));
maxDistance = 600;
distRange = linspace(minDist2Soma,maxDistance,500);
modelRatio = modelfun(exponentialFit.inhFraction.oneWithOffset.Coefficients.Estimate',...
    distRange);
% Figure properties
plot(distRange,modelRatio,'k');
legend('off')
xlabel([]);
ylabel([]);
ylim([0 1]);
xticks(0:300:maxDistance);
xlim([0,maxDistance]);
yticks(0:0.2:1);
ylim([0,1]);
x_width = 4;
y_width = 2.6;
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureRatio.svg','on','off');

%% Inhibitory density
beta0Inh = [0.1000,0.5824, -0.0299];
[fh,ax,exponentialFit.inhDensity] = dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,inhDensity,beta0Inh);
% Add L5st uncorrected
dendrite.L5.plotBeforeCorrection(L5stBeforeCorrection.inhDensity,inhDensity{end},...
    distance2soma{end});
x_width = 2;
y_width = 1.3;
% figure Properties
legend('off')
xlabel([]);
ylabel([]);
xticks(0:300:maxDistance);
xlim([0,maxDistance]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureShaft.svg','on','on');

%% excitatory synapse density
[fh,ax,exponentialFit.excDensity] = dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,excDensity);
% Add L5st uncorrected
dendrite.L5.plotBeforeCorrection(L5stBeforeCorrection.excDensity,excDensity{end},...
    distance2soma{end});
% Figure properties
legend('off')
xlabel([]);
ylabel([]);
ylim([0,6])
xticks(0:300:maxDistance);
xlim([0,maxDistance]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureSpine.svg','on','on');
disp(['Single exponential fit Rsquared, Excitatory: ',...
    num2str(exponentialFit.excDensity.oneWithOffset.Rsquared.Ordinary)]);

%% Write clustering results to excel sheet
excelFileName = fullfile(util.dir.getExcelDir(6),'Fig6AB.xlsx');
% Update the tree names to the current version
bifurT = struct2table(bifur,'RowNames',util.cellTypeNames);
bifurTcombined = table(cell(5,1),'VariableNames',{'combinedProp'},...
    'RowNames',util.cellTypeNames);
for i = 1:height(bifurT)
bifurTcombined{i,1}{1} = ...
    array2table(cat(2,bifurT{i,:}{:}),...
    'VariableNames',bifurT.Properties.VariableNames);
end
util.table.write(bifurTcombined, excelFileName);