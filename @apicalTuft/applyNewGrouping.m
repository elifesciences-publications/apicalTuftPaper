function outputOfMethod=applyNewGrouping...
    (apTuftArray,method, separategroups, createAggregate, ...
    annotationType,varargin)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('separategroups','var') || isempty (separategroups)
    separategroups=true;
end
if ~exist('createAggregate','var') || isempty (createAggregate)
    createAggregate=true;
end
if ~exist('annotationType','var') || isempty (annotationType)
    annotationType='both';
end

%Initial parameters
numDatasets=length(apTuftArray);
datasetNames=cellfun(@(x) x.dataset,apTuftArray,'UniformOutput',false);

groups2ApplyMethod=pickGroups;
if separategroups
    assert(~any(cellfun(@(x)x.legacyGrouping,apTuftArray)));
    % Use the groups of the first annotations, they should be the same
    rowNames=apTuftArray{1}.groupingVariable. ...
        Properties.VariableNames(groups2ApplyMethod);
    outputOfMethod=cell(length(rowNames),numDatasets);
    for d=1:numDatasets
        for g=1:length(groups2ApplyMethod)
            % Apply the method
            treeIndices=apTuftArray{d}. ...
                groupingVariable{1,groups2ApplyMethod(g)}{1};
            if ~isempty(treeIndices)
                outputOfMethod{g,d}=apTuftArray{d}. ...
                    (method)(treeIndices,varargin{:});
            end
        end
    end
else
    rowNames={['allTrees_',annotationType]};
    % All data aggregated
    outputOfMethod=cell(1,numDatasets);
    for dataset=1:numDatasets
        % Apply the method
        treeIndices=apTuftArray{dataset}.groupingVariable...
            (:,groups2ApplyMethod).Variables;
        treeIndices=cat(1,treeIndices{:});
        outputOfMethod{1,dataset}=apTuftArray{dataset}. ...
            (method)(treeIndices,varargin{:});
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

% This function is used to choose a subset of tree groups to apply a
% method, i.e. we don't want to measure synapse density on dist2soma
% annotations which do not contain synapses
    function groups=pickGroups
        switch annotationType
            case 'both'
                groups=1:length(apTuftArray{1}.groupingVariable. ...
                    Properties.VariableNames);
            case 'mapping'
                groups=find(cellfun(@(x) contains(x,annotationType),...
                    apTuftArray{1}.groupingVariable. ...
                    Properties.VariableNames));
            case 'dist2soma'
                groups=find(cellfun(@(x) contains(x,annotationType),...
                    apTuftArray{1}.groupingVariable. ...
                    Properties.VariableNames));
            otherwise
                error('Group name does not make sense')
        end
        % Make sure they all contain the name since you only used the 1st
        % one to get it -- exclude the both case
        if strcmp(annotationType,'mapping') || strcmp(annotationType,'dist2soma')
            groupNames=cellfun(@(x)x.groupingVariable. ...
                Properties.VariableNames(groups),apTuftArray,...
                'UniformOutput',false);
            groupNames=cat(2,groupNames{:});
            assert(all(cellfun(@(x) contains(x,annotationType),groupNames)));
        end
    end
end