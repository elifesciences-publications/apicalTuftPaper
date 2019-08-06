function [testResult] = KW(array,labels)
%KW applies kruskall wallis test to elements of a cell array
% Create array of data and labels for KW test
dataArray=cat(1,array{:});
lengths=cellfun(@length,array);
labelRepeated=repelem(labels(:),lengths);
% Apply KW test to find whether any group is significantly different from
% any other
[testResult.pKW,~,stats]=kruskalwallis(dataArray,labelRepeated,'off');
% Find groups that are significantly different using the multicomparison
% post-hoc test
[testResult.cMC] = multcompare(stats,'display','off');
testResult.tableMeanSEM=table(cellfun(@mean,array)',...
    cellfun(@util.stat.sem,array)','VariableNames',{'Mean','SEM'},...
    'RowNames',labels);
disp(['p-value from Kruskall Wallis test is: ',num2str(testResult.pKW)]);
disp(testResult.tableMeanSEM);
end

