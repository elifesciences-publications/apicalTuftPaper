%% Fractions of AD innervation used in results section:
% Preference of presynaptic axons for types of apical dendrites

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll
outputDir = fullfile(util.dir.getFig(3),'B');
util.mkdir(outputDir)
apTuft = apicalTuft.getObjects('inhibitoryAxon');

%% Fraction (in percent) of AD innervation
% Fraction of AD innervation overall
synRatios = apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getSynRatio');
targetNames = {'L2Apical','DeepApical'};
% The average
Means = cellfun(@(x) ...
    varfun(@(y)round(mean(y,1).*100,1),x,...
    'InputVariables',targetNames,'OutputFormat','uniform'),...
    synRatios.Aggregate,'UniformOutput',false);
Means = cat(1,Means{:});
% The standard error of the mean (SEM)
SEMs = cellfun(@(x) ...
    varfun(@(y)round(util.stat.sem(y,[],1).*100,1),x,...
    'InputVariables',targetNames,'OutputFormat','uniform'),...
    synRatios.Aggregate,'UniformOutput',false);
SEMs = cat(1,SEMs{:});
varNames = {'L2PercentMean','DeepPercentMean',...
    'L2PercentSEM','DeepPercentSEM'};
rowNames = {'layer2Seeded','DeepSeeded'};
percentOverall = array2table([Means,SEMs],'VariableNames',varNames,...
    'RowNames',rowNames);
% Write to table
writetable(percentOverall,...
    fullfile(outputDir,'ADInnervation_percent.xlsx'),...
    'WriteRowNames', true);

%% Get the mean+-sem for total apical targeting (pooling L2 and DL AD
% innervation for each axon)
totalApicalTargeting = cellfun(@(x)sum(x{:,targetNames},2),...
    synRatios.Aggregate,'UniformOutput',false);
totalApicalTargeting = cat(1,totalApicalTargeting{:});
percentTotal.mean = round(mean(totalApicalTargeting)*100,1);
percentTotal.sem = round(util.stat.sem(totalApicalTargeting,[],1)*100,1);
writetable(struct2table(percentTotal),...
    fullfile(outputDir,'totalADInnervation_percent.xlsx'));

%% numbers pooled over all synapses
% Get the fraction from the average over axons as well
synCountInd = ...
    apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount',true,true);
% Loop over seeds
percentOnlyAD = percentOverall;
for i = 1:2
    curCount = synCountInd.Aggregate{i};
    curL2Ratio = (curCount.L2Apical./...
        (curCount.L2Apical+curCount.DeepApical))*100;
    curDLRatio = (curCount.DeepApical./...
        (curCount.L2Apical+curCount.DeepApical))*100;
    % Fill out the table
    percentOnlyAD.L2PercentMean(i) = round(nanmean(curL2Ratio),2);
    percentOnlyAD.DeepPercentMean(i) = round(nanmean(curDLRatio),2);
    percentOnlyAD.L2PercentSEM(i) = round(util.stat.sem(curL2Ratio),2);
    percentOnlyAD.DeepPercentSEM(i) = round(util.stat.sem(curDLRatio),2);
end
writetable(percentOnlyAD,...
    fullfile(outputDir,'percentOnlyAD.xlsx'),'WriteRowNames',true);

%% Total synapse numbers: write to text file
synCount = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount',...
    false,true);
synCount = synCount.Aggregate{1}(:,2:end);
TotalSynNum = sum(synCount.Variables,'all');
l2SynNum = sum(synCount.L2Apical,'all');
dlSynNum = sum(synCount.DeepApical,'all');
% Absolute total number of synapses (minus the seeds) and AD synapses.
fid = fopen(fullfile(outputDir,'totalSynapseNumbers.txt'),'w+');
fprintf (fid, ['Total SynapseNumber: ',num2str(TotalSynNum),'\n']);
fprintf(fid, ['L2 syn number: ', num2str(l2SynNum),....
    '-----Deep syn number:',num2str(dlSynNum),'\n']);
fclose(fid);