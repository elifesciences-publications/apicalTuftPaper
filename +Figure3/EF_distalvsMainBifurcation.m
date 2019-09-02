% Author: Ali Karimi<ali.karimi@brain.mpg.de>
%% Distal tuft results from LPtA
util.clearAll;
distalSkel=apicalTuft('LPtA_l2vsl3vsl5');
distalSkel=distalSkel.sortTreesByName;

distal.synRatio=cell(3,1);
distal.synRatioWithGroups=cell(3,1);
for gr=1:3
    curRatio=distalSkel.getSynRatio(distalSkel.groupingVariable{1,gr}{1}).Shaft;
    distal.synRatio{gr}=curRatio;
end


outputFolder=fullfile(util.dir.getFig3,'distalvsMain');
util.mkdir(outputFolder)
util.setColors
x_width=3.1;
y_width=2.7;
colors={l2color,l3color,l5color};

% inhibitory Ratio
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(distal.synRatio,1:3,'ylim',1,'boxWidth',0.5,...
'color',colors);
xticklabels([]);
yticks(0:0.2:1)
ylabel([])
xlabel([])
xlim([0.5, 3.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction.svg');
%% Do Kruskall-Wallis test for the shaft Ratios
% Merge L2 and L2MN
mergeGroups = {[1,4]};
curLabels = cellTypeRatios.Properties.RowNames;
testResult = util.stat.KW(shaftRatio,curLabels,mergeGroups);
%% Also do the densities
x_width=2.3;
y_width=1.7;
colors={exccolor,exccolor,exccolor;inhcolor,inhcolor,inhcolor};
for gr=1:3
    curDense=distalSkel.getSynDensityPerType(distalSkel.groupingVariable{1,gr}{1});
    distal.shaftDensity{gr}=curDense.Shaft;
    distal.spineDensity{gr}=curDense.Spine;
end

allDensitites=[distal.spineDensity;distal.shaftDensity];
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(allDensitites(:),1:6,'ylim',10,'boxWidth',0.75,...
'color',colors(:));
set(ax,'yscale','log');
xticklabels([]);
ylabel([]);
xticks([]);
yticklabels([])
xlim([0.5,6.5])
ylim([0.06,10])
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

cellTypes={'L2','L3','L5'};
for celltype=1:3
    disp([cellTypes{celltype},': main bifurcation vs. distal tuft'])
    testResultsRatios.(cellTypes{celltype})=...
        util.stat.ranksum....
        (bifur.shaftRatio{celltype},distal.synRatio{celltype});
end
%% create the error bar for summary plot
fh=figure;ax=gca;
colors={l2color,l3color,l5color};
hold on

for celltype=1:3
    curField=cellTypes{celltype};
    curColor=colors{celltype};
    errorbar([2,1],testResultsRatios.(curField).mean,...
        testResultsRatios.(curField).sem,....
        'Color',curColor);
end
xlim([0.75, 2.25]);
ylim([0,0.4]);
xticks(1:2);
yticks(0:0.1:0.4)
xticklabels([]);
yticklabels([]);
x_width=2.7*2;
y_width=1.4*2;
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'summaryPlot.svg','off','on');
%% layer 5 excitatory shaft, spine synapse density and inhibitory fraction
util.stat.ranksum(bifur.spineDensity{3},distal.spineDensity{3});
util.stat.ranksum(bifur.shaftDensity{3},distal.shaftDensity{3});
disp(testResultsRatios.L5)
%% layer 2 excitatory shaft, spine synapse density and inhibitory fraction
util.stat.ranksum(bifur.spineDensity{1},distal.spineDensity{1});
util.stat.ranksum(bifur.shaftDensity{1},distal.shaftDensity{1});
disp(testResultsRatios.L2)
%% layer 3
util.stat.ranksum(bifur.shaftRatio{2},distal.synRatio{2});
util.stat.ranksum(bifur.shaftRatio{2},bifur.shaftRatio{3});
util.stat.ranksum(distal.synRatio{2},distal.synRatio{1});
%% Distal: Get the mean values for text
Means=cellfun(@(x)round(mean(x).*100,2),distal.synRatio);
Sems=cellfun(@(x) round(util.stat.sem(x,[],1).*100,3),distal.synRatio);

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