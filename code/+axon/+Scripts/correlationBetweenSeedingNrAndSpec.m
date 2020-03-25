%% Get correlation
targetingNr(1,:) = cellfun(@(x) (x.L2ApicalShaft+1),...
    targetingCount(1,:),'UniformOutput',false);
targetingNr(2,:) = cellfun(@(x) (x.DeepApicalShaft+1),...
    targetingCount(2,:),'UniformOutput',false);

%% Plotting
subplot(1,2,1);scatter(targetingNr{1,5},synRatio{1,5}.L2Apical,'filled','x',...
    'MarkerFaceColor',l2color,'MarkerEdgeColor',l2color)
l = lsline;
l.Color = [ 0 0 0];
title('Layer 2 Axons')
ylabel('TargetSpec')
ylim([0,1])
subplot(1,2,2);scatter(targetingNr{2,5},synRatio{2,5}.DeepApical,'filled','x',...
    'MarkerFaceColor',dlcolor,'MarkerEdgeColor',dlcolor)
l = lsline;
l.Color = [ 0 0 0];
title('Deep layer Axons')
ylim([0,1])
util.plot.cosmeticsSave(gcf,gca,40,10,outputDir,'correlationOfSpec');
