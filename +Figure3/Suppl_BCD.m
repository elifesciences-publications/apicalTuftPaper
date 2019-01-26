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
binSize=100000;
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

%% Get grand sample mean and  bootsrap error rates 

% Extract, synapse densities, inhibitory ratio, pathlength and the number of
% dendritic segments from the global (g) data table
ignoreThreshold=true;
% Control values for panel D
pathlength=dendrite.wholeApical.extractInformation(g,@nansum,...
    {'pathLengthInMicron'},ignoreThreshold);
pathlengthInMM=cell2mat(pathlength.pathLengthInMicron)./1000;
dendriteNum=cell2mat(dendrite.wholeApical.extractInformation(g,@length,...
    {'treeIdx'},ignoreThreshold).treeIdx);
% B and C panels
rawPerTypeAndDepth=dendrite.wholeApical.extractInformation(g,[],...
    {'Shaft_Count','Spine_Count','pathLengthInMicron'},ignoreThreshold);
concatRaw=cellfun(@(x,y,z)cat(2,x,y,z),...
    rawPerTypeAndDepth.Shaft_Count,rawPerTypeAndDepth.Spine_Count,...
    rawPerTypeAndDepth.pathLengthInMicron,'UniformOutput',false);
concatRawLinear=concatRaw(:);
results=table();
for i=1:length(concatRawLinear)
    curSample=concatRawLinear{i};
    
    func.inhDensity=@(x) sum(x(:,1))./sum(x(:,3));
    func.excDensity=@(x)sum(x(:,2))./sum(x(:,3));
    func.inhRatio=@(x)sum(x(:,1))./(sum(x(:,1))+sum(x(:,2)));
    % Note: matrices of size 1 are thought of as vectors and create an
    % error in the bootstrap function. We just use an error of 1
    if size(curSample,1)~=1
        % Here grand sample mean and bootstrap confidence interval 
        % (nboot = 10000) is calculated
        curResult.inhDensity=util.stat.bootCI(...
            func.inhDensity,curSample);
        curResult.excDensity=util.stat.bootCI(...
            func.excDensity,curSample);
        curResult.inhRatio=util.stat.bootCI(...
            func.inhRatio,curSample);
    else
        disp('sample is a vector, size(dim 1)==1');
        disp(curSample);
        curResult.inhDensity=repmat(func.inhDensity(curSample),1,3);
        curResult.inhRatio=repmat(func.inhRatio(curSample), 1,3);
        curResult.excDensity=repmat(func.excDensity(curSample),1,3);
    end
    % Make sure nan is all or none
    assert(all(structfun(@(x)~any(isnan(x)),curResult) | ...
        structfun(@(x)all(isnan(x)),curResult)));
    curResultCell=structfun(@(x){x},curResult,'UniformOutput',false);
    results=[results;struct2table( curResultCell)];
end
resultsByCellType=util.varfunKeepNames...
    (@(x)reshape(x,size(concatRaw)),results);

%% Suppl. Fig. 3b-d
% Note: lsat bin only cotains data between 200 and 310 um. For it to be not
% misleading we change the center of the plot to 310 instead of 350
binRange=100;
binLims=[0:binRange:300,320];
binCenters=[50:binRange:300,310];
stairLocations=[binCenters(1:end-1)-(binRange/2),300];
% Groups: 1: L2, 2: Deep, 3: L3, 4: L5
cellTypes=[1:4];
outputDir=fullfile(util.dir.getFig3,'Suppl_B-D');
util.mkdir(outputDir)
colors={l2color,dlcolor,l3color,l5color};
% C: synapse densities
fh=figure;ax=gca;
x_width=9;
y_width=4.6;
lineStyle={'-','--'};
measure={'inhDensity','excDensity'};
hold on
for t=cellTypes
    for m=1:2
        curCI=cell2mat(resultsByCellType.(measure{m})(:,t));
        util.plot.shadeCI(curCI,colors{t},binCenters,lineStyle{m});
    end
end
xlim([0 binLims(end)]);
ytickangle(90)
ylim([0,5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'synapsDensities.svg','on','on',false);
hold off

% B: inhibitory ratio
x_width=9;
y_width=4.6;
fh=figure;ax=gca;
hold on
for t=cellTypes
    curCI=cell2mat(resultsByCellType.inhRatio(:,t));
    util.plot.shadeCI(curCI,colors{t},binCenters,'-');
end
ylim([0,0.3])
ytickangle(90)
xlim([0 binLims(end)])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,'inhRatioControl.svg',...
    'on','on',false);

% D1: total pathlength in mm
x_width=9;
y_width=2.6;% 3
fh=figure;ax=gca;

hold on

for t=cellTypes
    counts=pathlengthInMM(:,t);
    util.plot.stairs(stairLocations,counts(:)','Color',colors{t})
end
xlim([0 max(binLims)])
ytickangle(90)
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,...
    'pathLengthHistogram.svg','on','on');

% D2: total dendrite number
x_width=9;
y_width=2.6;
fh=figure;ax=gca;

hold on
for t=cellTypes
    counts=dendriteNum(:,t);
    util.plot.stairs(stairLocations,counts,'Color',colors{t})
end
xlim([0 max(binLims)]);
ytickangle(90)
ylim([0 50])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputDir,...
    'dendriteNumber.svg','on','on');
%% Number of dendrites and pathlength Control and number for text
% rawPerTypeAndDepth comes from the g table
valuesFromBinning=util.varfunKeepNames(@(x)nansum(cell2mat(x(:))),...
    rawPerTypeAndDepth);
    
% Get values separately from the intact (not binned/sliced) annotations to
% compare
% Synapse numbers:
valuesUnbinned=table();
S1V2PPCACC_allDendrites=dendrite.wholeApical.mergeBifurcation_WholeApical(4);
LPtAPPC2=apicalTuft.getObjects('l2vsl3vsl5');
% sum the values comming from l2vsl3vsl5 and l2vsdeep
synCountUnbinned{1}=dendrite.getSynapseNumbers(S1V2PPCACC_allDendrites);
synCountUnbinned{2}=dendrite.getSynapseNumbers(LPtAPPC2);
synCountsTotal=synCountUnbinned{1}('Aggregate',:).Variables+...
    synCountUnbinned{2}('Aggregate',:).Variables;
valuesUnbinned.Shaft_Count=synCountsTotal(1);
valuesUnbinned.Spine_Count=synCountsTotal(2);
% Path length from unsliced
allBackbones=[table2cell(backBone.allDend),table2cell(backBone.l235)];
valuesUnbinned.pathLengthInMicron=...
    sum(cellfun(@(x) x.getTotalBackonePath,...
    allBackbones));
totalApicalDendriteNumber=sum(cellfun(@(x)length(x.names),allBackbones));
% Comparison:
disp(valuesFromBinning)
disp(valuesUnbinned)