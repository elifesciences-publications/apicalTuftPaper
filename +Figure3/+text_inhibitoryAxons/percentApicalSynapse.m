% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Get apical targeting percent used in the result text
util.clearAll
outputDir=fullfile(util.dir.getFig(3),'forText_inhibitoryAxon');
util.mkdir(outputDir)
%% Numbers averaged over axons
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synRatios=apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getSynRatio');
% Get the mean and SEMs for L2 vs Deep targeting of axons seeded at L2 vs
% Deep
Means=cellfun(@(x) varfun(@(y)round(mean(y,1).*100,1),x(:,2:3)),...
    synRatios.Aggregate,'UniformOutput',false);
Means=cat(1,Means{:});
Means.Properties.VariableNames={'L2PercentMean','DeepPercentMean'};
SEMs=cellfun(@(x) ...
    varfun(@(y) round(util.stat.sem(y,[],1).*100,1),x(:,2:3)),...
    synRatios.Aggregate,'UniformOutput',false);
SEMs=cat(1,SEMs{:});
SEMs.Properties.VariableNames={'L2PercentSEM','DeepPercentSEM'};
percentData=[Means,SEMs];
percentData.Properties.RowNames={'layer2Seeded','DeepSeeded'};
writetable(percentData,...
    fullfile(outputDir,'percentIndividualSeedType.xlsx'),...
    'WriteRowNames', true);


% Get the mean+-sem for total apical targeting
totalApicalTargeting=cellfun(@(x)sum(x{:,2:3},2),...
    synRatios.Aggregate,'UniformOutput',false);
totalApicalTargeting=cat(1,totalApicalTargeting{:});
percentTotal.mean=round(mean(totalApicalTargeting)*100,1);
percentTotal.sem=round(util.stat.sem(totalApicalTargeting,[],1)*100,1);
writetable(struct2table(percentTotal),...
    fullfile(outputDir,'percentTotal.xlsx'));
util.copyfiles2fileServer;
%% numbers pooled over all synapses
% Fraction of spine synapses which are single

synCount=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount',...
    false,true);
synCount = synCount.Aggregate{1}(:,2:end);
synCountSingle= sum(synCount.SpineSingle);
synCountDouble = sum(synCount.SpineDouble);
spineSingleFraction = synCountSingle ./ (synCountSingle+synCountDouble);
% Get the fraction from the average over axons as well
synCountInd = ...
    apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount',true,true);
% Loop over seeds
percentApical = percentData;
for i=1:2
    curCount = synCountInd.Aggregate{i};
    curL2Ratio = (curCount.L2Apical./...
        (curCount.L2Apical+curCount.DeepApical))*100;
    curDLRatio = (curCount.DeepApical./...
        (curCount.L2Apical+curCount.DeepApical))*100;
    % Fill out the table
    percentApical.L2PercentMean(i) = round(nanmean(curL2Ratio),2);
    percentApical.DeepPercentMean(i) = round(nanmean(curDLRatio),2);
    percentApical.L2PercentSEM(i) = round(util.stat.sem(curL2Ratio),2);
    percentApical.DeepPercentSEM(i) = round(util.stat.sem(curDLRatio),2);
end
writetable(percentApical,...
    fullfile(outputDir,'percentApical.xlsx'),'WriteRowNames',true);
% Write to text file
fid=fopen(fullfile(outputDir,'SynNumbersTotal.txt'),'w+');
fprintf (fid,['Fraction of Double innervated spines (of total spines): ', ...
    num2str(1-spineSingleFraction),'\n']);
TotalSynNum=sum(synCount.Variables,'all');
fprintf (fid, ['Total SynapseNumber: ',num2str(TotalSynNum),'\n']);
l2SynNum = sum(synCount.L2Apical,'all');
dlSynNum = sum(synCount.DeepApical,'all');
fprintf(fid, ['L2 syn number: ', num2str(l2SynNum),....
    '-----Deep syn number:',num2str(dlSynNum),'\n']);
fprintf(fid, ['Total fraction of synapses', ...
    num2str((l2SynNum+dlSynNum)./TotalSynNum),'\n']);
fclose(fid);

util.copyfiles2fileServer;