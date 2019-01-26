% Author: Ali Karimi<ali.karimi@brain.mpg.de>

util.clearAll;
skel=apicalTuft('PPC2_l2vsl3vsl5');
skel=skel.sortTreesByName;
cellTypeRatios=skel.applyMethod2ObjectArray({skel},...
    'getSynRatio',[],false,'mapping');
distance2soma=skel.applyMethod2ObjectArray({skel},...
    'pathLength',[],false,'dist2soma');
cellTypeDensity=skel.applyMethod2ObjectArray({skel},...
    'getSynDensityPerType',[],false,'mapping');

shaftRatio=cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
shaftDensity=cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
spineDensity=cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);
distance2soma=cellfun(@(x) x.pathLengthInMicron,distance2soma.Variables,...
    'UniformOutput',false);

%% Plotting for Figure 3: inhibitoy ratio
outputFolder=fullfile(util.dir.getFig3,'cellTypeComparison');
util.mkdir(outputFolder)
util.setColors
x_width=5.3*2;
y_width=3.5*2;
colors={l2color,l3color,l5color};

% inhibitory Ratio
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(shaftRatio,1:3,'ylim',1,'boxWidth',0.5,...
'color',colors);
xticklabels([]);
yticks(0:0.2:1)
ylabel([])
xlabel([])
xlim([0.5, 3.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction.svg');
%% Do an anova test for the ratios
[p,tbl,stats]=kruskalwallis(cat(2,shaftRatio{:}));
c=multcompare(stats);
%% Get the mean values for text, before the anova test report, Fig. 3b
Means=cellfun(@(x)round(mean(x),2),shaftRatio);
Sems=cellfun(@(x) round(util.stat.sem(x,[],1),3),shaftRatio);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)
%% Plotting for Figure 3: synapse density
outputFolder=fullfile(util.dir.getFig3,'cellTypeComparison');
util.mkdir(outputFolder)
util.setColors
x_width=10;
y_width=8;
colors={exccolor,exccolor,exccolor;inhcolor,inhcolor,inhcolor};
allDensitites=[spineDensity';shaftDensity'];
% Density plot
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(allDensitites(:),1:6,'ylim',10,'boxWidth',0.5,...
'color',colors(:));
set(ax,'yscale','log');
xticklabels([]);
ylabel([]);
xticks([]);
xlim([0.5,6.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.svg','off','on');

%% Get the layer 2 numbers form main bifurcation annotaitons and add them to
% the other layer 2 results
% main bifurcation to soma distance vs. inhibitory fraction at the main
% bifurcation

apDim=apicalTuft.getObjects('apicalDiameter');
b.distance2Soma=apicalTuft. ...
    applyMethod2ObjectArray(apDim,'getSomaDistance',...
    [],[],[],'bifurcation');

bifur=apicalTuft.getObjects('bifurcation');
b.ratios=apicalTuft.applyMethod2ObjectArray...
    (bifur,'getSynRatio');
b.Densities=apicalTuft.applyMethod2ObjectArray...
    (bifur,'getSynDensityPerType');
b.shaftRatio=cellfun(@(x) x.Shaft,b.ratios.Variables,'UniformOutput',false);

% Use bifurcaiton coordinate to match annotations between apicalDiameter
% and bifurcation input mapping
bifurCoordinates.inh=apicalTuft. ...
    applyMethod2ObjectArray(bifur,'getBifurcationCoord',[],[],[],false);
bifurCoordinates.SomaLoc=apicalTuft. ...
    applyMethod2ObjectArray(apDim,'getBifurcationCoord',[],[],[],false);
fun=@(x,y) intersect(x,y,'rows');
[~,index.inh,index.SomaLoc]=cellfun(fun,bifurCoordinates.inh.Variables,bifurCoordinates.SomaLoc.Variables,...
    'UniformOutput',false);

% Update Layer 2 section with bifurcation mapping results
shaftRatio{1}=[shaftRatio{1};b.shaftRatio{1,5}(index.inh{1,5})];
shaftDensity{1}=[shaftDensity{1};...
    b.Densities.Aggregate{1}.Shaft];
spineDensity{1}=[spineDensity{1};...
    b.Densities.Aggregate{1}.Spine];
distance2soma{1}=[distance2soma{1};...
    cell2mat(b.distance2Soma.Aggregate{1}.distance2Soma(index.SomaLoc{1,5}))];


%%  = Correlation and Exponential fit
outputFolder=fullfile(util.dir.getFig3,'cellTypeComparison');

% Inhibitory Ratio
[fh,ax,exponentialFit_Ratio]=dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,shaftRatio);
x_width=14;
y_width=7;
% plot exponential with offset
minDist2Soma=min(cell2mat(distance2soma));
modelfun = @(b,x)(b(1)+b(2)*exp(b(3)*x));
distRange=linspace(minDist2Soma,500,500);
modelRatio=modelfun(exponentialFit_Ratio.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');
legend('off')
xlabel([]);
ylabel([]);
ylim([0 1]);
xticks(0:100:500);
xlim([0,500]);
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
x_width=7.5;
y_width=5;
% plot exponential with offset
modelRatio=modelfun(exponentialFit_inh.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');

legend('off')
xlabel([]);
ylabel([]);
xticks(0:250:500);
xlim([0,500]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureShaft.svg','on','on');
disp(['Single exponential fit Rsquared, Ratio: ',...
    num2str(exponentialFit_inh.oneWithOff.Rsquared.Ordinary)]);


% spineDensity
[fh,ax,exponentialFit_Exc]=dendrite.l2vsl3vsl5.plotCorrelation...
    (distance2soma,spineDensity);
x_width=7.5;
y_width=5;
% plot exponential with offset
modelRatio=modelfun(exponentialFit_Exc.oneWithOff.Coefficients.Estimate',...
    distRange);
plot(distRange,modelRatio,'k');
legend('off')
xlabel([]);
ylabel([]);
ylim([0,6])
xticks(0:250:500);
xlim([0,500]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'coorrelationFigureSpine.svg','on','on');
disp(['Single exponential fit Rsquared, Ratio: ',...
    num2str(exponentialFit_Exc.oneWithOff.Rsquared.Ordinary)]);