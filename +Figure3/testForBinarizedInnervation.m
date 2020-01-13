util.clearAll;
skel=apicalTuft.getObjects('inhibitoryAxon');
outputDir=fullfile(util.dir.getFig(3),'TestForMultiInnervation');
util.mkdir(outputDir);
%% Most important: find the number of targeting per target group
% results dims: cell: dataset, array: treeIdx,target
% apical type (1: L2, 2: dl), seed apical type (1: L2, 2,dl)
targetCount = cell(4,1);
seedType = {'l2Idx','dlIdx'};
MultiPerDataset = cellfun(@axon.multipleTargeting.extractMultipleTargeting, ...
    skel,'UniformOutput',false);
for d=1:length(skel)
    for s = 1:2
        curTotal = [sum(MultiPerDataset{d}{skel{d}.(seedType{s}),'L2Apical'},2)+...
            sum(MultiPerDataset{d}{skel{d}.(seedType{s}),'DeepApical'},2)];
        curL2 = sum(MultiPerDataset{d}{skel{d}.(seedType{s}),'L2Apical'},2);
        curDL = sum(MultiPerDataset{d}{skel{d}.(seedType{s}),'DeepApical'},2);
        targetCount{d,s} = [curL2 ./ curTotal,curDL ./ curTotal];
        curSum = sum(targetCount{d,s},2);
        assert(all(curSum(~isnan(curSum))==1))
    end
end

%% Test
filename = fullfile(outputDir,'testResult_IndividualL2targetFraction_L2seeded-deepSeeded.txt');
count.l2Seeded = cat(1,targetCount{:,1});
count.deepSeeded =  cat(1,targetCount{:,2});
% remove nans
count.l2Seeded(isnan(count.l2Seeded(:,1)),:) = []; 
count.deepSeeded(isnan(count.deepSeeded(:,1)),:) = [];
util.stat.ranksum(count.l2Seeded(:,1),count.deepSeeded(:,1),filename);
util.copyfiles2fileServer

fractionAvgOverAxon = ...
    reshape(struct2array(structfun(...
    @(x)mean(x,1),count,'UniformOutput',false)),2,2)';

util.plot.probabilityMatrix(...
    fractionAvgOverAxon,fullfile(outputDir,...
    ['TheAvgOverAxons_IndividualTargetFraction','.svg']));