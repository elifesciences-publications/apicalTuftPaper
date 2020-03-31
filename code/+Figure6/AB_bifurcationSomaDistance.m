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

% Create cell arrays used for plotting
shaftRatio = cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
shaftDensity = cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
spineDensity = cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);
distance2soma = distance2somaRaw.Variables;
%% Set the values of the L5st group to the corrected values and 
% also keep the uncorrected values for later plotting 
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
    evalin('base',[variableNames{i},'{end} = curCorrected']);
end

%% Get the layer 2 numbers form main bifurcation annotations and add them to
% the other layer 2 results
% main bifurcation to soma distance vs. inhibitory fraction at the main
% bifurcation
curVariables = {'shaftRatio','shaftDensity','spineDensity','distance2soma'};
% Create the bifur structure as the input
for i = 1:length(curVariables)
    bifur.(curVariables{i}) = evalin('base',curVariables{i});
end

% Concatenation
bifur = dendrite.l2vsl3vsl5.concatenateSmallDatasetL2(bifur);

% Set the values to the concatenated values
for i = 1:length(curVariables)
    assignin('base',curVariables{i},...
        bifur.(curVariables{i}))
end

%% Correlation and Exponential fit
% Inhibitory Ratio
[fh,ax,exponentialFit_Ratio] = dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,shaftRatio);
% Add L5A uncorrected
dendrite.L5.plotUncorrected(l5ARawData.shaftRatio,shaftRatio{end},...
    distance2soma{end});
x_width = 4;
y_width = 2.6;
xLimit = 600;
% plot exponential with offset
minDist2Soma = min(cell2mat(distance2soma));
modelfun = @(b,x)(b(1)+b(2)*exp(b(3)*x));
distRange = linspace(minDist2Soma,xLimit,500);
modelRatio = modelfun(exponentialFit_Ratio.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');
legend('off')
xlabel([]);
ylabel([]);
ylim([0 1]);
xticks(0:300:xLimit);
xlim([0,xLimit]);
yticks(0:0.2:1);
ylim([0,1]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureRatio.svg','on','off');
disp(['Single exponential fit Rsquared, Inh. ratio: ',...
    num2str(exponentialFit_Ratio.oneWithOff.Rsquared.Ordinary)]);


% shaft density
beta0Inh = [0.1000,0.5824, -0.0299];
[fh,ax,exponentialFit_inh] = dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,shaftDensity,beta0Inh);
% Add L5A uncorrected
dendrite.L5.plotUncorrected(l5ARawData.shaftDensity,shaftDensity{end},...
    distance2soma{end});
x_width = 2;
y_width = 1.3;
% plot exponential with offset
modelRatio = modelfun(exponentialFit_inh.oneWithOff.Coefficients.Estimate',...
    distRange);
% plot(distRange,modelRatio,'k');

legend('off')
xlabel([]);
ylabel([]);
xticks(0:300:xLimit);
xlim([0,xLimit]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureShaft.svg','on','on');
disp(['Single exponential fit Rsquared, Inhibitory: ',...
    num2str(exponentialFit_inh.oneWithOff.Rsquared.Ordinary)]);

% spineDensity
[fh,ax,exponentialFit_Exc] = dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,spineDensity);

% Add L5A uncorrected
dendrite.L5.plotUncorrected(l5ARawData.spineDensity,spineDensity{end},...
    distance2soma{end});


% plot exponential with offset
modelRatio = modelfun(exponentialFit_Exc.oneWithOff.Coefficients.Estimate',...
    distRange);
% plot(distRange,modelRatio,'k');
legend('off')
xlabel([]);
ylabel([]);
ylim([0,6])
xticks(0:300:xLimit);
xlim([0,xLimit]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureSpine.svg','on','on');
disp(['Single exponential fit Rsquared, Excitatory: ',...
    num2str(exponentialFit_Exc.oneWithOff.Rsquared.Ordinary)]);