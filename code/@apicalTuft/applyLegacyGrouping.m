function  outputOfMethod=applyLegacyGrouping...
    (apTuftArray,method, separategroups, createAggregate,varargin)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('separategroups','var') || isempty (separategroups)
    separategroups=true;
end
if ~exist('createAggregate','var') || isempty (createAggregate)
    createAggregate=true;
end
% Make sure all objects are legacy grouping
legacyGrouping=cellfun(@(x)x.legacyGrouping,apTuftArray);
assert(all(legacyGrouping(:)));

%Initial parameters
numDatasets=length(apTuftArray);
datasetNames=cellfun(@(x) x.dataset,apTuftArray,'UniformOutput',false);

if separategroups
    % Separated L2 and Deep
    rowNames={'layer2','deepLayer'};
    outputOfMethod=cell(2,numDatasets);
    for d=1:numDatasets
        if isempty(apTuftArray{d}.l2Idx) && isempty(apTuftArray{d}.dlIdx)
            warning('Both L2 and DL groups are empty');
        end
        % Apply the method
        if ~isempty(apTuftArray{d}.l2Idx)
            outputOfMethod{1,d}=apTuftArray{d}. ...
                (method)(apTuftArray{d}.l2Idx,varargin{:});
        end
        if ~isempty(apTuftArray{d}.dlIdx)
            outputOfMethod{2,d}=apTuftArray{d}. ...
                (method)(apTuftArray{d}.dlIdx,varargin{:});
        end
    end
else
    rowNames={'allTrees'};
    % All data aggregated
    outputOfMethod=cell(1,numDatasets);
    for dataset=1:numDatasets
        % Apply the method
        outputOfMethod{1,dataset}=apTuftArray{dataset}.(method)...
            ([],varargin{:});
    end
end

% Aggregate the data from all the datasets into and additional column
if createAggregate
    try
        for g=1:size(outputOfMethod,1)
            outputOfMethod{g,numDatasets+1}=...
                cat(1,outputOfMethod{g,1:numDatasets});
        end
        datasetNames=cat(2,datasetNames,{'Aggregate'});
    catch
        disp('concatenation of results not possible');
    end
end
outputOfMethod=cell2table(outputOfMethod,'VariableNames',datasetNames,...
    'RowNames',rowNames);
end