function [] = plotKernelDensity(thisMeasure,colors)
% PLOTKERNELDENSITY hack for the kernel density plot of the dendrite
% Remove the empty tags
emptyIdx = cellfun(@isempty,thisMeasure);
thisMeasure = thisMeasure(~emptyIdx);
colors = colors(~emptyIdx);
thisMeasure_UC = cellfun(@(x) x(:,1),thisMeasure,...
    'UniformOutput',false);
thisMeasure_C = cellfun(@(x) x(:,2),thisMeasure,...
    'UniformOutput',false);
hold on
%yyaxis(gca,'left')
for i = 1:length(thisMeasure_C)
%     histogram(thisMeasure_C{i},'BinEdges',0:0.1:1 ,...
%         'DisplayStyle','stairs','EdgeColor',colors{i},...
%         'Normalization','probability');
%     histogram(thisMeasure_UC{i},'BinEdges',0:0.1:1 ,...
%         'DisplayStyle','stairs','EdgeColor',[0,0,0],...
%         'Normalization','probability');
end
%yyaxis(gca,'right')
util.plot.ksdensity(thisMeasure_UC,...
    colors,[],[0,1]);
util.plot.ksdensity(thisMeasure_C,colors,[],[0,1]);
end

