% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll

original.allDend=dendrite.wholeApical.mergeBifurcation_WholeApical(4);
original.allDend=cell2table(original.allDend,'VariableNames',...
    {'S1','V2','PPC','ACC'});
original.l235=apicalTuft.getObjects('l2vsl3vsl5',[],true);
% remove dist2soma annotations
original.l235.PPC2=original.l235.PPC2.deleteTrees(...
    original.l235.PPC2.getTreeWithName('mapping','partial'),true);
% Sort all annotation trees by name
sortFun=@(annotGroup) util.varfunKeepNames ...
    (@(thisAnnot) thisAnnot.sortTreesByName,annotGroup);
originalSorted=...
    structfun(sortFun,original,'UniformOutput',false);

% Convert all annotations into y axis being pia distance (y=0, pia)
fun=@ (annot) apicalTuft.applyMethod2ObjectArray...
    (annot,'convert2PiaCoord',false,false,'mapping');
converted=structfun(fun,originalSorted,'UniformOutput',false);

% associate synapses with backbone nodes
% Note: nodes with the same coordinate (Double nodes) need to be removed
% before the association with backbone works. These nodes create Inf
% distances if on path between spine and backbone
synOnBackBoneFun=@ (annot) apicalTuft.applyMethod2ObjectArray...
    (annot,'associateSynWithBackBone',false,false,'mapping');
synIDOnBackBone=structfun(synOnBackBoneFun,converted,...
    'UniformOutput',false);

% Get the shaft backbone of the annotations
fun=@(annot) apicalTuft.applyMethod2ObjectArray...
    (annot,'getBackBone',false,false,'mapping');
backBone=structfun(fun, synIDOnBackBone,'UniformOutput',false);
% Crop out lowres part of LPtA dataset, both the backbone and the full
% annotation
backBone.l235.LPtA=backBone.l235.LPtA.cropoutLowRes;

% Get the bboxes used for chopping along Pia-WM
binSize=20000;
bboxes=util.bbox.slicePiaWMaxis([table2cell(backBone.l235),...
    table2cell(backBone.allDend)],binSize);
bboxfun=@(annot) cellfun(...
    @annot.restrictToBBoxWithInterpolation,...
    bboxes,'UniformOutput',false);
annotTableFun=@ (annotTable)...
    util.varfunKeepNames(@(annot) bboxfun(annot),annotTable);
chopped=structfun(annotTableFun,backBone,...
    'UniformOutput',false);

% Split into connected components
% combine all annotations
splitCC=dendrite.wholeApical.iterateOverBboxes(chopped,'splitCC');

% Gather all the information
allInfo=dendrite.wholeApical.iterateOverBboxes...
    (splitCC,'getFullInfoTableCC',...
    true,true,true);
% Group annotations into L2, L3, L5 and L3-5
% measure mean +- SEM for Deep (L3-5) and L2 groups for plotting.
% Measurements include: inhibitory density, excitatory density and inhibitory ratio
% also report total path length and dendrite CC numbers at each depth
g=table();
g.l2=cellfun(@(depth)depth{'layer2','Aggregate'},allInfo.allDend);
g.l2=cellfun(@dendrite.wholeApical.catL2,...
    allInfo.l235,g.l2,'UniformOutput',false);
g.deep=cellfun(@(depth)depth{'deepLayer','Aggregate'},allInfo.allDend);

g.l3=cellfun(@(depth)depth{'layer3ApicalDendrite_mapping','Aggregate'},...
    allInfo.l235);
g.l5=cellfun(@(depth)depth{'layer5ApicalDendrite_mapping','Aggregate'},...
    allInfo.l235);

% Gather results
densityRatio.mean=dendrite.wholeApical.extractInformation(g,@nanmean,...
    {'Shaft_Count_Density','Spine_Count_Density','Shaft_Ratio'});

densityRatio.sem=dendrite.wholeApical.extractInformation(g,...
    @(x)util.stat.sem(x,[],1),...
    {'Shaft_Count_Density','Spine_Count_Density','Shaft_Ratio'});

% Gather PPC2 results for scatter plots
bifurCoords=apicalTuft.applyMethod2ObjectArray...
    ({converted.l235.PPC2},'getBifurcationCoord');
synRatio=apicalTuft.applyMethod2ObjectArray...
    ({converted.l235.PPC2},'getSynRatio');
density=apicalTuft.applyMethod2ObjectArray...
    ({converted.l235.PPC2},'getSynDensityPerType');
for tr=1:10
    bifurCoord.l3(tr)=bifurCoords{2,1}{1}(tr,2)./1000;
    bifurCoord.l5(tr)=bifurCoords{3,1}{1}(tr,2)./1000;
    sp.l3(:,tr)=[bifurCoord.l3(tr);density{2,1}{1}.Spine(tr)];
    sp.l5(:,tr)=[bifurCoord.l5(tr);density{3,1}{1}.Spine(tr)];
    sh.l3(:,tr)=[bifurCoord.l3(tr);density{2,1}{1}.Shaft(tr)];
    sh.l5(:,tr)=[bifurCoord.l5(tr);density{3,1}{1}.Shaft(tr)];
    rat.l3(:,tr)=[bifurCoord.l3(tr);synRatio{2,1}{1}.Shaft(tr)];
    rat.l5(:,tr)=[bifurCoord.l5(tr);synRatio{3,1}{1}.Shaft(tr)];
end
% for controls
numberAndPathLength=dendrite.wholeApical.extractInformation(g,@sum,...
    {'combinedThresh','pathLengthInMicron'});
numberAndPathLength=util.varfunKeepNames(@cell2mat,numberAndPathLength);
numberAndPathLength.combinedThresh(...
    isnan(numberAndPathLength.combinedThresh))=0;
numberAndPathLength.pathLengthInMicron(...
    isnan(numberAndPathLength.pathLengthInMicron))=0;
numberAndPathLength.pathLengthInMM=numberAndPathLength. ...
    pathLengthInMicron./1000;
%% Plots main Figure: Only LPtA data in L1
% Get the mean and SEM for the plots
onlyL1LPtA=table();
onlyL1LPtA.l2=cellfun(@(x) x{'layer2ApicalDendrite_mapping','LPtA'}{1},...
    allInfo.l235,'UniformOutput',false);
onlyL1LPtA.l3=cellfun(@(x) x{'layer3ApicalDendrite_mapping','LPtA'}{1},...
    allInfo.l235,'UniformOutput',false);
onlyL1LPtA.l5=cellfun(@(x) x{'layer5ApicalDendrite_mapping','LPtA'}{1},...
    allInfo.l235,'UniformOutput',false);
onlyL1_densityRatio.mean=dendrite.wholeApical.extractInformation(onlyL1LPtA,@nanmean,...
    {'Shaft_Count_Density','Spine_Count_Density','Shaft_Ratio'});
onlyL1_densityRatio.sem=dendrite.wholeApical.extractInformation(onlyL1LPtA,...
    @(x)util.stat.sem(x,[],1),...
    {'Shaft_Count_Density','Spine_Count_Density','Shaft_Ratio'});
% Plotting the mean +-SEM for excitatory, inhibitory and inh. ratio
binRange=20;
binLims=0:binRange:320;
binCenters=10:20:310;
stairLocations=binCenters-(binRange/2);
xlimit=120;
% Groups: 1: L2, 2: Deep, 3: L3, 4: L5
cellTypes=[1:3];
plotScatter=false;
x_width=6;
y_width=3;
fh=figure;ax=gca;
outputDir=fullfile(util.dir.getFig3,'EH');
util.mkdir(outputDir)
colors={l2color,l3color,l5color};
lineStyle={'-','--'};
hold on
for t=cellTypes
    for d=1:2
        thisMean=cell2mat(onlyL1_densityRatio.mean{:,d}(:,t))';
        thisSem=cell2mat(onlyL1_densityRatio.sem{:,d}(:,t))';
        disp(thisMean);
        disp(thisSem)
        util.plot.shade(thisMean,thisSem,colors{t},binCenters,lineStyle{d});
    end
end
if plotScatter
util.plot.scatter(sp.l3,l3color,[],'square');
util.plot.scatter(sp.l5,l5color,[],'square');
util.plot.scatter(sh.l3,l3color);
util.plot.scatter(sh.l5,l5color);
end
xlim([0 xlimit]);
yticks(1:3)
xticklabels([]);
yticklabels([]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'densityE.svg','on','on',false);
hold off

% F
x_width=6;
y_width=3;
fh=figure;ax=gca;

hold on
for t=cellTypes
    thisMean=cell2mat(onlyL1_densityRatio.mean{:,3}(:,t))';
    thisSem=cell2mat(onlyL1_densityRatio.sem{:,3}(:,t))';
    util.plot.shade(thisMean,thisSem,colors{t},binCenters);
    
end
if plotScatter
util.plot.scatter(rat.l3,l3color);
util.plot.scatter(rat.l5,l5color);
end
ylim([0,0.4])
yticks([0:0.2:0.4])
xlim([0 xlimit])
xticklabels([]);
yticklabels([]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'RatioF.svg','on','on');
% Testing the difference between L2,L3 and L5
rawValues=dendrite.wholeApical.extractInformation(onlyL1LPtA,[],...
    {'Shaft_Count_Density','Spine_Count_Density','Shaft_Ratio'});
rawDistalRatio.l2=cell2mat(rawValues.Shaft_Ratio(2:6,1));
rawDistalRatio.l3=cell2mat(rawValues.Shaft_Ratio(2:6,2));
rawDistalRatio.l5=cell2mat(rawValues.Shaft_Ratio(2:6,3));
util.stat.ranksum(rawDistalRatio.l3,rawDistalRatio.l2);
util.stat.ranksum(rawDistalRatio.l2,rawDistalRatio.l5);
util.stat.ranksum(rawDistalRatio.l3,rawDistalRatio.l5);
% L5 and others significant L2 and L3 non-significant
%% Plots: Supplementary
% E
% There's a nan edge at the end
binRange=20;
binLims=0:binRange:320;
binCenters=10:20:310;
stairLocations=binCenters-(binRange/2);
% Groups: 1: L2, 2: Deep, 3: L3, 4: L5
cellTypes=[1:4];
plotScatter=false;
x_width=12;
y_width=7;
fh=figure;ax=gca;
outputDir=fullfile(util.dir.getFig3,'EH');
util.mkdir(outputDir)
colors={l2color,dlcolor,l3color,l5color};
lineStyle={'-','--'};
hold on
for t=cellTypes
    for d=1:2
        thisMean=cell2mat(densityRatio.mean{:,d}(:,t))';
        thisSem=cell2mat(densityRatio.sem{:,d}(:,t))';
        disp(thisMean);
        disp(thisSem)
        util.plot.shade(thisMean,thisSem,colors{t},binCenters,lineStyle{d});
    end
end
if plotScatter
util.plot.scatter(sp.l3,l3color,[],'square');
util.plot.scatter(sp.l5,l5color,[],'square');
util.plot.scatter(sh.l3,l3color);
util.plot.scatter(sh.l5,l5color);
end
xlim([0 binLims(end)])

util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'densityE.svg','on','on',false);
hold off

% F
x_width=12;
y_width=7;
fh=figure;ax=gca;

hold on
for t=cellTypes
    thisMean=cell2mat(densityRatio.mean{:,3}(:,t))';
    thisSem=cell2mat(densityRatio.sem{:,3}(:,t))';
    util.plot.shade(thisMean,thisSem,colors{t},binCenters);
    
end
if plotScatter
util.plot.scatter(rat.l3,l3color);
util.plot.scatter(rat.l5,l5color);
end
ylim([0,1])
xlim([0 binLims(end)])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'RatioF.svg','on','on');

% G
x_width=12;
y_width=3;% 3
fh=figure;ax=gca;

hold on

for t=cellTypes
    counts=numberAndPathLength.combinedThresh(:,t);
    util.plot.stairs(stairLocations,counts(:)','Color',colors{t})
end
xlim([0 max(binLims)])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'CCG.svg','on','on');

% H
x_width=12;
y_width=3;
fh=figure;ax=gca;

hold on
for t=cellTypes
    counts=numberAndPathLength.pathLengthInMM(:,t);
    util.plot.stairs(stairLocations,counts,'Color',colors{t})
end
xlim([0 max(binLims)])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'pathH.svg','on','on');

%% Text numbers, distal (20-80 um) vs main bifurcation region (140-200um)
distal=g(2:4,:);
mainBifurRegion=g(8:10,:);
for i=1:4
    distal{4,i}={cat(1,distal{:,i}{:})};
    mainBifurRegion{4,i}={cat(1,mainBifurRegion{:,i}{:})};
end
metrics={'Shaft_Count_Density','Spine_Count_Density','Shaft_Ratio'};
% Gather results
distalResult.mean=dendrite.wholeApical.extractInformation(distal,@nanmean,...
    metrics);
distalResult.sem=dendrite.wholeApical.extractInformation(distal,...
    @(x)util.stat.sem(x,[],1),...
    metrics);
distalResult.number=dendrite.wholeApical.extractInformation(distal,@length,...
    metrics);

mainBifurResult.mean=dendrite.wholeApical.extractInformation(mainBifurRegion,@nanmean,...
    metrics);
mainBifurResult.sem=dendrite.wholeApical.extractInformation(mainBifurRegion,...
    @(x)util.stat.sem(x,[],1),...
    metrics);
mainBifurResult.number=dendrite.wholeApical.extractInformation(mainBifurRegion,@length,...
    metrics);
fun=@(x) array2table(transpose(reshape(cell2mat(x{4,:}),4,[])),...
    'VariableNames',g.Properties.VariableNames,'RowNames',metrics);
% Discard indicdual results and only keep the aggregates
distalResultCleaned=structfun(fun,...
    distalResult,'UniformOutput',false);
mainBifurResultCleaned=structfun(fun,...
    mainBifurResult,'UniformOutput',false);
disp('Distal results (20-80 um) are:')
disp(distalResultCleaned.mean)
disp(distalResultCleaned.sem)
disp(distalResultCleaned.number)
disp('Main Bifurcation results (140-200 um) are:')
disp(mainBifurResultCleaned.mean)
disp(mainBifurResultCleaned.sem)
disp(mainBifurResultCleaned.number)
%% ranksum testing for the latest version of text
% L5
l5MB=mainBifurRegion.deep{4}.Shaft_Ratio...
    (mainBifurRegion.deep{4}.combinedThresh>0);
l5DT=distal.l5{4}.Shaft_Ratio(distal.l5{4}.combinedThresh>0);
util.stat.ranksum(l5MB,l5DT)

l5MBSpine=mainBifurRegion. ...
    deep{4}.Spine_Count_Density(mainBifurRegion.deep{4}.combinedThresh>0);
l5DTSpine=distal.l5{4}.Spine_Count_Density(distal.l5{4}.combinedThresh>0);
util.stat.ranksum(l5MBSpine,l5DTSpine)

l5MBShaft=mainBifurRegion. ...
    deep{4}.Shaft_Count_Density(mainBifurRegion.deep{4}.combinedThresh>0);
l5DTShaft=distal.l5{4}.Shaft_Count_Density(distal.l5{4}.combinedThresh>0);
util.stat.ranksum(l5MBShaft,l5DTShaft)

% L2
l2MBSpine=mainBifurRegion. ...
    l2{4}.Spine_Count_Density(mainBifurRegion.l2{4}.combinedThresh>0);
l2DTSpine=distal.l2{4}.Spine_Count_Density(distal.l2{4}.combinedThresh>0);
util.stat.ranksum(l2MBSpine,l2DTSpine)

l2MBShaft=mainBifurRegion. ...
    l2{4}.Shaft_Count_Density(mainBifurRegion.l2{4}.combinedThresh>0);
l2DTShaft=distal.l2{4}.Shaft_Count_Density(distal.l2{4}.combinedThresh>0);
util.stat.ranksum(l2MBShaft,l2DTShaft)

l2MBRatio=mainBifurRegion. ...
    l2{4}.Shaft_Ratio(mainBifurRegion.l2{4}.combinedThresh>0);
l2DTRatio=distal.l2{4}.Shaft_Ratio(distal.l2{4}.combinedThresh>0);
util.stat.ranksum(l2MBRatio,l2DTRatio)

%% Boxplot for debugging the L2 results
% F
x_width=12;
y_width=7;
fh=figure;ax=gca;
ShRatio=dendrite.wholeApical.extractInformation(g,[],{'Shaft_Ratio'});
hold on
thisMean=cell2mat(densityRatio.mean{:,3}(:,1))';
thisSem=cell2mat(densityRatio.sem{:,3}(:,1))';
util.plot.shade(thisMean,thisSem,colors{1},binCenters);
util.plot.boxPlotRawOverlay(ShRatio.Shaft_Ratio(:,1),num2cell(binCenters)',...
    'color',repmat({l2color},length(binCenters),1),'boxWidth',5)

ylim([0,1])
xlim([0 max(binLims)])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'testL2.svg','on','on');