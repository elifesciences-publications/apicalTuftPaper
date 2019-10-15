% Author: Ali Karimi<ali.karimi@brain.mpg.de>

util.clearAll;
outputFolder=fullfile(util.dir.getFig5,...
    'cellType_SynapticDensity_Comparison_Correlation');
util.mkdir(outputFolder);

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
results = dendrite.synSwitch.getCorrected.getAllRatioAndDensityResult;
% Keep only the main bifurcation results from L5A (L5st) group
resultsL5A = results.l235{end,:}{1};
% varibales for assigning
variableNames={'shaftRatio','shaftDensity','spineDensity'};
tableVariableNames={'Shaft_Ratio','Shaft_Density','Spine_Density'};
for i=1:3
    curUncorrected=evalin('base',[variableNames{i},'{end}']);
    curCorrected=resultsL5A.(tableVariableNames{i})(:,2);
    assert(isequal(curUncorrected,resultsL5A.(tableVariableNames{i})(:,1)));
    % save uncorrected (raw values for plotting later)
    l5ARawData.(variableNames{i}) = curUncorrected;
    % Change values to corrected for plotting
    evalin('base',[variableNames{i},'{end} = curCorrected']);
end
%% Plotting for Figure 5: inhibitoy ratio
util.mkdir (outputFolder)
util.setColors
x_width=3;
y_width=3.8;
colors=util.plot.getColors().l2vsl3vsl5;
indices=[1,2,3,1,4];
% inhibitory Ratio
fname = 'ShaftFraction_mainBifurcation';
fh=figure('Name',fname);ax=gca;
mkrSize=10;
noisyXValues=...
    util.plot.boxPlotRawOverlay(shaftRatio,indices,'ylim',1,'boxWidth',0.5496,...
    'color',colors,'tickSize',mkrSize);
% Make sure order of corrected and uncorrected values match
L5Ahorizontal = noisyXValues{end}(1,:)';
assert( isequal(noisyXValues{end}(2,:)', resultsL5A.Shaft_Ratio(:,2)) );

% Plot the uncorrected L5A values as grey crosses and connect them with a
% line
dendrite.L5A.plotUncorrected(l5ARawData.shaftRatio,shaftRatio{end},...
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
    'L2L2MNComparison_ShaftRation'))
util.stat.ranksum(shaftRatio{3},shaftRatio{5},fullfile(outputFolder,...
    'L5ttL5stComparison_ShaftRation'));

% KW test for ecitatory and inhibitory synapse density as well
testResult.Exc = util.stat.KW(spineDensity,curLabels,mergeGroups,...
    fullfile(outputFolder,'excDensity'));
testResult.Inh = util.stat.KW(shaftDensity,curLabels,mergeGroups,...
    fullfile(outputFolder,'inhDensity'));
util.copyfiles2fileServer;
%% Plotting for Figure 5: synapse density
util.mkdir(outputFolder)
x_width = 2;
y_width = 2.2;
colors = [repmat({exccolor},1,5);repmat({inhcolor},1,5)];
allDensitites = [spineDensity';shaftDensity'];
% Merge L2 with L2MN
densityIndices = 1:10;
densityIndices(7:8)=1:2;
densityIndices(9:10)=7:8;
% Density plot
fh = figure;ax = gca;
curXLoc=util.plot.boxPlotRawOverlay(allDensitites(:),densityIndices(:),...
    'ylim',10,'boxWidth',0.5,'color',colors(:),'tickSize',10);

% Get the uncorrected values and concatenate the excitatory and inhibitory
% synapse densities
curXLoc=cat(2,curXLoc{end-1:end})';
thisUnCorrected=[l5ARawData.spineDensity;l5ARawData.shaftDensity];

% Add the L5A raw data points
dendrite.L5A.plotUncorrected(thisUnCorrected,curXLoc(:,2),curXLoc(:,1))

% Fig props
set(ax,'yscale','log');
yticks([0.1,1,10]);
yticklabels([0.1,1,10]);
xlim([0.5,8.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.svg','off','on');

%% Get the layer 2 numbers form main bifurcation annotaitons and add them to
% the other layer 2 results
% main bifurcation to soma distance vs. inhibitory fraction at the main
% bifurcation
curVariables = {'shaftRatio','shaftDensity','spineDensity','distance2soma'};
% Create the bifur structure as the input
for i = 1:length(curVariables)
    bifur.(curVariables{i})=evalin('base',curVariables{i});
end

% Concatenation
bifur = dendrite.l2vsl3vsl5.concatenateSmallDatasetL2(bifur);

% Set the values to the concatenated values
for i=1:length(curVariables)
    assignin('base',curVariables{i},...
        bifur.(curVariables{i}))
end

%% Correlation and Exponential fit
% Inhibitory Ratio
[fh,ax,exponentialFit_Ratio]=dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,shaftRatio);
% Add L5A uncorrected
dendrite.L5A.plotUncorrected(l5ARawData.shaftRatio,shaftRatio{end},...
    distance2soma{end});
x_width=4;
y_width=2.6;
xLimit = 600;
% plot exponential with offset
minDist2Soma=min(cell2mat(distance2soma));
modelfun = @(b,x)(b(1)+b(2)*exp(b(3)*x));
distRange=linspace(minDist2Soma,xLimit,500);
modelRatio=modelfun(exponentialFit_Ratio.oneWithOff.Coefficients.Estimate',...
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
disp(['Single exponential fit Rsquared, Ratio: ',...
    num2str(exponentialFit_Ratio.oneWithOff.Rsquared.Ordinary)]);


% shaft density
beta0Inh=[0.1000,0.5824, -0.0299];
[fh,ax,exponentialFit_inh]=dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,shaftDensity,beta0Inh);
% Add L5A uncorrected
dendrite.L5A.plotUncorrected(l5ARawData.shaftDensity,shaftDensity{end},...
    distance2soma{end});
x_width=4;
y_width=2.6;
% plot exponential with offset
modelRatio=modelfun(exponentialFit_inh.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');

legend('off')
xlabel([]);
ylabel([]);
xticks(0:300:xLimit);
xlim([0,xLimit]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureShaft.svg','on','on');
disp(['Single exponential fit Rsquared, Ratio: ',...
    num2str(exponentialFit_inh.oneWithOff.Rsquared.Ordinary)]);

% spineDensity
[fh,ax,exponentialFit_Exc]=dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,spineDensity);

% Add L5A uncorrected
dendrite.L5A.plotUncorrected(l5ARawData.spineDensity,spineDensity{end},...
    distance2soma{end});


% plot exponential with offset
modelRatio=modelfun(exponentialFit_Exc.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');
legend('off')
xlabel([]);
ylabel([]);
ylim([0,6])
xticks(0:300:xLimit);
xlim([0,xLimit]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureSpine.svg','on','on');
disp(['Single exponential fit Rsquared, Ratio: ',...
    num2str(exponentialFit_Exc.oneWithOff.Rsquared.Ordinary)]);