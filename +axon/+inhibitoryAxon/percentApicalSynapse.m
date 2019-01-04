% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Get apical targeting percent used in the result text
util.clearAll
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
disp(percentData);

%Get the mean+-sem for total apical targeting
totalApicalTargeting=cellfun(@(x)sum(x{:,2:3},2),...
    synRatios.Aggregate,'UniformOutput',false);
totalApicalTargeting=cat(1,totalApicalTargeting{:});
percentTotal.mean=round(mean(totalApicalTargeting)*100,1);
percentTotal.sem=round(util.stat.sem(totalApicalTargeting,[],1)*100,1);
disp(percentTotal);


