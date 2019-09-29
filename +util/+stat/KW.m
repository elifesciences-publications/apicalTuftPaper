function [testResult] = KW(array,labels,mergeGroups,fname)
%KW applies kruskall wallis test to elements of a cell array
% Create array of data and labels for KW test
% Merge groups specified
if  ~exist('mergeGroups','var') || isempty(mergeGroups)
else
    for i=1:length(mergeGroups)
        curIdx=mergeGroups{i};
        array{curIdx(1)}=[array{curIdx(1)};array{curIdx(2)}];
        labels(curIdx(2))=[];
        array(curIdx(2))=[];
    end
end
if ~exist('fname','var') || isempty(fname)
    writeResult=false;
else
    writeResult=true;
end

array = array(:)';
dataArray = cat(1,array{:});
lengths = cellfun(@length,array);
labelRepeated = repelem(labels(:),lengths);
% Apply KW test to find whether any group is significantly different from
% any other
[testResult.pKW,~,stats] = kruskalwallis(dataArray,labelRepeated,'off');
% Find groups that are significantly different using the multicomparison
% post-hoc test
[testResult.cMC] = multcompare(stats,'display','off');
testResult.tableMeanSEM = table(cellfun(@mean,array)',...
    cellfun(@util.stat.sem,array)','VariableNames',{'Mean','SEM'},...
    'RowNames',labels);
disp(['p-value from Kruskall Wallis test is: ',num2str(testResult.pKW)]);
disp(testResult.tableMeanSEM);
% Write each field in a separate text file
if writeResult
    writetable(array2table(testResult.pKW),...
        [fname,'pvalKW.xlsx'])
    writetable(array2table(testResult.cMC,...
    'VariableNames',{'index1','index2','lowerBound',...
    'actualMedianDiff','upperBound','pValues'}),...
    [fname,'multCompare.xlsx']);
    writetable(testResult.tableMeanSEM,...
        [fname,'meanSEM.xlsx'],'WriteRowNames',true);
end
end

