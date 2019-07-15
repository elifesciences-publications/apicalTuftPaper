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

%% First step remove all the seed targeting see how
% that affects the results
for d=1:length(skel)
    figure('Name',skel{d}.filename)
    ratioMinusSeed=axon.multipleTargeting.getRatioMinusSeed(skel{d});
    util.plot.boxPlotRawOverlay([num2cell(ratioMinusSeed.l2Idx{:,2:3},1),...
        num2cell(ratioMinusSeed.dlIdx{:,2:3},1)])
end
%% Next plot correlation between seed targeting and fraction of other
% synapses on target
axon.multipleTargeting.plotCorrelation(ratioMinusSeed)

%% Most important: find the number of targeting per target group
% results dims: cell: dataset, array: number of syn on target,target
% apical type (1: L2, 2: dl), seed apical type (1: L2, 2,dl)
results={zeros(10,2,2),zeros(10,2,2)};
for d=1:length(skel)
    MultiPerDataset{d}=axon.multipleTargeting. ...
        extractMultipleTargeting(skel{d});
    seedType={'l2Idx','dlIdx'};
    for seed=1:2
        results{d}(:,:,seed)=...
            [sum(MultiPerDataset{d}{skel{d}.(seedType{seed}),'L2Apical'},1)',...
            sum(MultiPerDataset{d}{skel{d}.(seedType{seed}),'DeepApical'},1)'];
    end
end

% check that the total number of synapse in the apical dendrite groups
% match with what we get from syncount
seedTag={'l2Idx','dlIdx'};
for d=1:length(skel)
    for seedT=1:2
        trIndices=skel{d}.(seedTag{seedT});
        synCount=skel{d}.getSynCount(trIndices);
        curSynCountSum=sum(synCount{:,2:3});
        seedCounts=MultiPerDataset{d}.seedTargetingNr(trIndices,:);
        seedCounts(:,seedT)=seedCounts(:,seedT)-1;
        additionalSeedSynapses=sum(seedCounts,1);
        allOtherSyn=sum(results{d}(:,:,seedT).*[1:10]',[1,3]);
        disp(seedTag{seedT});
        disp(curSynCountSum);
        disp((allOtherSyn+additionalSeedSynapses))
    end
end
%% The histogram of the number of times axons target apical dendrites
% Afggregated over datasets
% separated by the seed tyepe (L2, Vs. DL)
allData=results{1}+results{2}+results{3}+results{4};
colors={l2color,dlcolor};
maxSynNumber=6;
x_width=10;y_width=7;
outputDir=fullfile(util.dir.getFig2,'TheMultiInnervation');
for d=1:2
    fh{d}=figure;ax{d}=gca;
    l2Target=allData(1:maxSynNumber,1,d);
    dltarget=allData(1:maxSynNumber,2,d);
    hold on
    histogram('BinEdges',0:maxSynNumber,'BinCounts', l2Target,...
        'DisplayStyle','stairs','EdgeColor',l2color);
    histogram('BinEdges',0:maxSynNumber,'BinCounts', dltarget,...
        'DisplayStyle','stairs','EdgeColor',dlcolor);
    set(ax{d},'XTick',0.5:1:maxSynNumber+0.5,'XTickLabel',1:maxSynNumber)
    util.plot.cosmeticsSave(fh{d},ax{d},x_width,y_width,...
        outputDir,'histogram.svg');
    hold off
end
%% Plot probability matrices
% two plots:
% 1. per AD: each target counted as one no matter how many times targeted
% 2. per synapse: multiply by number of targets
fname={fullfile(outputDir,'perDendriteTarget.svg'),...
    fullfile(outputDir,'perSynapse.svg')};
correctionFactor={ones(10,1),[1:10]'};
for i=1:length(correctionFactor)
    sumData=squeeze(sum(allData.*correctionFactor{i},1));
    squeeze(sum(allData,1));
    % individual synapse fraction 
    % (multiply individual target by the number of hits)
    sumData=sumData./sum(sumData,2);
    util.plot.probabilityMatrix(sumData,fname{i});
    disp(sumData)
end