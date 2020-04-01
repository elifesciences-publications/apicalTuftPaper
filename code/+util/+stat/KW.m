function [testResult] = KW(array,labels,mergeGroups,fname)
% KW applies kruskall wallis test to elements of a cell array
% Groups could be merged if necessary and results could be written to a
% file with "fname". The test is followed by Tukey's range test to find
% significantly different pairs. 

% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if  ~exist('mergeGroups','var') || isempty(mergeGroups)
    % do nothing
else
    % Merge groups with given Idx pair into the initial Id cell
    for i = 1:length(mergeGroups)
        curIdx = mergeGroups{i};
        assert (length(curIdx)==2,'Length check')
        array{curIdx(1)} = [array{curIdx(1)};array{curIdx(2)}];
        labels(curIdx(2)) = [];
        array(curIdx(2)) = [];
    end
end
if ~exist('fname','var') || isempty(fname)
    writeResult = false;
else
    writeResult = true;
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
[testResult.cMC] = multcompare(stats,'display','off',...
    'CType','tukey-kramer');
testResult.tableMeanSEM = table(cellfun(@mean,array)',...
    cellfun(@(d)util.stat.sem(d,[],1),array)',cellfun(@length,array)',...
    'VariableNames',{'Mean','SEM','Number'},...
    'RowNames',labels);

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

