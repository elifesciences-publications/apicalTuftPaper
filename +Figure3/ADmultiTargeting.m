% This script is to extract multiple targeting of apical dendrites by
% axons.
% Annotation style:
% In the annotation seed targeting is mentioned with the following format:
% seed X: X is the number of times the seed is targeted
% Other apical dendrite related synapses have an added _x at the end such
% as: spineOfDeepApicalDendrite_DoubleInnervated_1: first synapse on a
% double-innervated spine of deep apical dendrite
util.clearAll;
skel=apicalTuft.getObjects('inhibitoryAxon');
outputDir=fullfile(util.dir.getFig3,'TheMultiInnervation');
util.mkdir(outputDir);
%% Most important: find the number of targeting per target group
% results dims: cell: dataset, array: number of syn on target,target
% apical type (1: L2, 2: dl), seed apical type (1: L2, 2,dl)
results = {zeros(10,2,2),zeros(10,2,2)};
MultiPerDataset = cell(1,length(skel));
seedType = {'l2Idx','dlIdx'};
for d=1:length(skel)
    MultiPerDataset{d} = axon.multipleTargeting.extractMultipleTargeting...
        (skel{d});
    for s = 1:2
        results{d}(:,:,s) = ...
            [sum(MultiPerDataset{d}{skel{d}.(seedType{s}),'L2Apical'},1)',...
            sum(MultiPerDataset{d}{skel{d}.(seedType{s}),'DeepApical'},1)'];
    end
end
% Check the total number of synapses
axon.multipleTargeting.checkTotalSynapseNumber(skel,MultiPerDataset,results)

%% Seed targeting: histogram of number of times the seed is targeted
colors={l2color,dlcolor};
seedTag={'l2Idx','dlIdx'};
fname='NumberOfSeedTargeting';
fh=figure('Name',fname);ax=gca;
x_width=3;y_width = 1.5;
maxSynNumber = 7;
hold on
for i=1:2
    trIndicesStruct.(seedTag{i})=...
        cellfun(@(x) x.(seedTag{i}),skel,'UniformOutput',false);
    seedTargeting.(seedTag{i})=...
        cellfun(@(x,y) x.seedTargetingNr(y,i),MultiPerDataset,...
        trIndicesStruct.(seedTag{i}),'uni',0);
    seedTargeting.(seedTag{i})=cat(1,seedTargeting.(seedTag{i}){:});
    histogram(seedTargeting.(seedTag{i}),'BinEdges',1:maxSynNumber+1,...
        'DisplayStyle','stairs','EdgeColor',colors{i},...
        'Normalization','probability');
end
hold off

set(ax,'XTick',1.5:1:maxSynNumber+1.5,'XTickLabel',1:maxSynNumber+1,...
        'YLim',[0,1])
util.plot.cosmeticsSave(fh,ax,x_width,y_width,...
    outputDir,[fname,'.svg']);
% Ranksum testing: not significant
util.stat.ranksum(seedTargeting.l2Idx,seedTargeting.dlIdx);
%% The histogram of the number of times axons target apical dendrites
% Aggregated over datasets
% separated by the seed tyepe (L2, Vs. DL)
allData=results{1}+results{2}+results{3}+results{4};
colors={l2color,dlcolor};
maxSynNumber=6;
x_width=2.2;y_width=2.2;
fnames={'L2Seeded','DeepSeeded'};
for d=1:2
    fh=figure('Name',fnames{d});ax=gca;
    l2Target=allData(1:maxSynNumber,1,d);
    dltarget=allData(1:maxSynNumber,2,d);
    hold on
    histogram('BinEdges',0:maxSynNumber,'BinCounts', l2Target,...
        'DisplayStyle','stairs','EdgeColor',l2color,...
        'Normalization','probability');
    histogram('BinEdges',0:maxSynNumber,'BinCounts', dltarget,...
        'DisplayStyle','stairs','EdgeColor',dlcolor,...
        'Normalization','probability');
    set(ax,'XTick',0.5:1:maxSynNumber+0.5,'XTickLabel',1:maxSynNumber,...
        'YLim',[0,1])
    util.plot.cosmeticsSave(fh,ax,x_width,y_width,...
        outputDir,[fnames{d},'.svg']);
    hold off
end
%% Boxplot of average number of synapses per target for each axon
% Aggregate data based on the seed type
clear targetingPerSeedType
for s=1:2
    for d=1:length(skel)
    targetingPerSeedType.(seedType{s}){d} = ...
        MultiPerDataset{d}(skel{d}.(seedType{s}),...
        {'L2Apical','DeepApical'});
    end
   targetingPerSeedType.([seedType{s},'seeded']) = ... 
       cat(1,targetingPerSeedType.(seedType{s}){:});
end
seed={'l2Idxseeded','dlIdxseeded'};
targets=targetingPerSeedType.dlIdxseeded.Properties.VariableNames;
for s=1:2
    for t=1:2
    curTargetingDist=targetingPerSeedType.(seed{s}).(targets{t});
    curTotalSynNummer=sum(curTargetingDist.*[1:size(curTargetingDist,2)],2);
    curTotalTargetNummer = sum(curTargetingDist,2);
    curSynPerTarget=curTotalSynNummer./curTotalTargetNummer;
    % remove the nans  for axons with no synapse on target
    curSynPerTarget = curSynPerTarget(~isnan(curSynPerTarget));
    avgSynPerAxon{s,t} = curSynPerTarget;
    end
end

%% Plot as a boxplot
fh=figure;ax=gca;
colors=repmat({l2color,dlcolor},1,2);
x_width=2.5;
y_width=2.5;
util.plot.boxPlotRawOverlay(avgSynPerAxon(:),1:4,...
    'ylim',4.5,'boxWidth',0.5496,'color',colors(:),'tickSize',10);
yticks(0:4);yticklabels(0:4);
xticks([])

disp('L2Seeded: ')
util.stat.ranksum(avgSynPerAxon{1,1},avgSynPerAxon{1,2},...
    fullfile(outputDir,'L2Seeded_avgSynPerAxon'));
disp('DeepSeeded')
util.stat.ranksum(avgSynPerAxon{2,1},avgSynPerAxon{2,2},...
    fullfile(outputDir,'DeepSeeded_avgSynPerAxon'));
disp('L2seededvsDeepSeeded');
util.stat.ranksum([avgSynPerAxon{1,1};avgSynPerAxon{1,2}],...
    [avgSynPerAxon{2,1};avgSynPerAxon{2,2}],...
    fullfile(outputDir,'L2seededvsDeepSeeded_avgSynPerAxon'));
% Write to table
curfname=fullfile(outputDir,'synPerTarget');
axonNumberWithADSynInEachGroup = ...
    array2table(cellfun(@length,avgSynPerAxon),'VariableNames',...
    {'L2Target','DeepTarget'},'RowNames',{'L2SeededAxons','DeepSeededAxons'});
writetable(axonNumberWithADSynInEachGroup,[curfname,'.xlsx']);

% Save fig
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,[],[fname,'.svg']);
%% Plot probability matrices
% two plots:
% 1. per AD: each target counted as one no matter how many times targeted
% 2. per synapse: multiply by number of targets
% 3. Average over individual axons
fname={fullfile(outputDir,'perDendriteTarget'),...
    fullfile(outputDir,'perSynapse'),...
    fullfile(outputDir,'averageOverAxons')};
correctionFactor={ones(10,1),[1:10]'};
addTheSeed = false;
if addTheSeed
    seedTargetingCount = structfun(@(x) accumarray(x,1),...
        seedTargeting,'UniformOutput',false);
    seedArray=cat(3,[seedTargetingCount.l2Idx;0],...
        seedTargetingCount.dlIdx);
    % Add zeros to the size
    seedArray(:,2,2) = 0;
    % Flip the second dimension for the Deep seeded axon values
    seedArray(:,:,2) = fliplr(seedArray(:,:,2));
    % Remove the seed synapse itself leaving the rest
    seedArray(1,:,:)=[];
    curAllData=allData+padarray(seedArray,4,0,'post')
else
    curAllData=allData;
end
for i=1:length(correctionFactor)
    sumData=squeeze(sum(curAllData.*correctionFactor{i},1));
    squeeze(sum(curAllData,1));
    % individual synapse fraction
    % (multiply individual target by the number of hits)
    sumData=sumData./sum(sumData,2);
    probTable = array2table(sumData,'VariableNames',...
    {'L2Target','DeepTarget'},'RowNames',{'L2SeededAxons','DeepSeededAxons'});
    writetable(probTable,[fname{i},'.xlsx']);
    util.plot.probabilityMatrix(sumData,[fname{i},'.svg']);

end

%% Also plot average over axons

apTuft = apicalTuft.getObjects('inhibitoryAxon');
synRatios=apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getSynRatio');
synRatios=synRatios{:,5};
apicalRatioTargetingAveragedOverAxons = ...
    array2table(zeros(2,2),'VariableNames',...
    {'L2Target','DeepTarget'},'RowNames',{'L2SeededAxons','DeepSeededAxons'});
apicalRatioTargetingAveragedOverAxons {:,1} = ...
    cellfun(@(x) nanmean(x.L2Apical./(x.L2Apical+x.DeepApical)),synRatios);
apicalRatioTargetingAveragedOverAxons {:,2} = ...
    cellfun(@(x) nanmean(x.DeepApical./(x.L2Apical+x.DeepApical)),synRatios);
    writetable(apicalRatioTargetingAveragedOverAxons,[fname{3},'.xlsx'],...
        'WriteRowNames',true);
util.plot.probabilityMatrix(apicalRatioTargetingAveragedOverAxons.Variables,[fname{3},'.svg']);