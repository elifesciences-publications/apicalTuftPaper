% Author: Ali Karimi<ali.karimi@brain.mpg.de>
%% Distal tuft results from LPtA
util.clearAll;
distalSkel = apicalTuft('LPtA_l2vsl3vsl5');
distalSkel = distalSkel.sortTreesByName;
L5ASkel = apicalTuft('PPC2L5ADistal_l2vsl3vsl5');
L5ASkel = L5ASkel.sortTreesByName;

distal = dendrite.l2vsl3vsl5.getRatioDensities(distalSkel);
distalL5A = dendrite.l2vsl3vsl5.getRatioDensities(L5ASkel);
% Merge L5A results from the PPC2 dataset with the results fronm the L5A
% dataset
vars=fieldnames(distal);
for i=1:length(vars)
    distal.(vars{i})=[distal.(vars{i});distalL5A.(vars{i})];
end
%% Plot inhibitory Ratios
outputFolder=fullfile(util.dir.getFig3,'distalvsMain');
util.mkdir(outputFolder);
util.setColors;
x_width=3;
y_width=3;
colors={l2color,l3color,l5color,l5Acolor};

fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(distal.shaftRatio,1:4,'ylim',1,'boxWidth',0.5,...
'color',colors,'tickSize',15);
xticklabels([]);
yticks(0:0.2:1);
xlim([0.5, 4.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction.svg');

%% Do Kruskall-Wallis test for the shaft Ratios
% Merge L2 and L2MN
cellTypes = {'L2','L3','L5B','L5A'};
testResult = util.stat.KW(distal.shaftRatio,cellTypes);

%% Also do the densities
x_width=2;
y_width=2;
colors=[repmat({exccolor},1,4);repmat({inhcolor},1,4)];

allDensitites=[distal.spineDensity';distal.shaftDensity'];
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(allDensitites(:),1:8,'ylim',10,'boxWidth',0.75,...
'color',colors(:),'tickSize',10);
set(ax,'yscale','log');
xticklabels([]);

xlim([0.5,8.5])
ylim([0.1,10])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.svg','off','on');


%% Do single cell type between regions comparison:
skel=apicalTuft('PPC2_l2vsl3vsl5');
skel=skel.sortTreesByName;
cellTypeRatios=skel.applyMethod2ObjectArray({skel},...
    'getSynRatio',[],false,'mapping');
cellTypeDensity=skel.applyMethod2ObjectArray({skel},...
    'getSynDensityPerType',[],false,'mapping');

bifur.shaftRatio=cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
bifur.shaftDensity=cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
bifur.spineDensity=cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);

% Get the layer 2 numbers form main bifurcation annotations and add them to
% the other layer 2 results
bifur=dendrite.l2vsl3vsl5.concatenateSmallDatasetL2(bifur);
% Also combine the L2MN group with the L2 group for the comparison
f=fieldnames(bifur);
for i=1:length(f)
    bifur.(f{i}){1}=[bifur.(f{i}){1};bifur.(f{i}){4}];
    bifur.(f{i})(4)=[];
end
for celltype=1:length(cellTypes)
    disp([cellTypes{celltype},': main bifurcation vs. distal tuft'])
    testResultsRatios.(cellTypes{celltype})=...
        util.stat.ranksum....
        (bifur.shaftRatio{celltype},distal.shaftRatio{celltype});
end
%% create the error bar for summary plot
fh=figure;ax=gca;
colors={l2color,l3color,l5color,l5Acolor};
hold on

for celltype=1:length(cellTypes)
    curField=cellTypes{celltype};
    curColor=colors{celltype};
    errorbar([2,1],testResultsRatios.(curField).mean,...
        testResultsRatios.(curField).sem,....
        'Color',curColor);
end
xlim([0.75, 2.25]);
ylim([0,0.6]);
xticks(1:2);
yticks(0:0.1:0.6)
xticklabels([]);
x_width=3.6;
y_width=1.7;
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
Means=cellfun(@(x)round(mean(x).*100,2),distal.shaftRatio);
Sems=cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),distal.shaftRatio);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)
%% Bifurcation: Get the mean values for text
Means=cellfun(@(x)round(mean(x).*100,2),bifur.shaftRatio);
Sems=cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),bifur.shaftRatio);

disp('Means (l2vs.l3vs.l5):')
disp(Means)
disp('Sems (l2vs.l3vs.l5):')
disp(Sems)