function [variablesForPlot] = rearrangeArrayForPlot(results,...
    layerOriginOrDataset,variables)
%REARRANGEARRAYFORPLOT rearranges tables with all the data to pick specific
%variables for plotting. This plotting variables contains structure with
%each one having a cell array inside for the cell type
% Note: results feilds should match layerOrigin
% Note: layerOriginOrDataset contains either dataset (bifur datasets) or
% Note: layer of focus (main bifurcation or distalAd) in cellType datasets
aggregateDatasetResults=false;
if  ~exist('layerOriginOrDataset','var') || isempty(layerOriginOrDataset)
    layerOriginOrDataset=results.Properties.VariableNames;
else
    % Note: Using 'All' as layerOriginOrDataset combines all the results
    if strcmp(layerOriginOrDataset{1},'All')
        layerOriginOrDataset=results.Properties.VariableNames;
        aggregateDatasetResults=true;
    end
end


for l=1:length(layerOriginOrDataset)
    curResults=results.(layerOriginOrDataset{l});
    indices=~cellfun(@isempty,curResults);
    for i=1:length(variables)
        % Note: Having a cell array component(2 cells) in the variables combines
        % the two variables for correlation plotting
        if ~iscell(variables{i})
            variablesForPlot.(layerOriginOrDataset{l}).(variables{i})(indices)=...
                cellfun(@(x) x.(variables{i}),curResults(indices),...
                'UniformOutput',false);
        else
            variablesForPlot.(layerOriginOrDataset{l}). ...
                ([variables{i}{1},'_',variables{i}{2}])(indices)=...
                cellfun(@(x) [x.(variables{i}{1}),x.(variables{i}{2})],...
                curResults(indices),'UniformOutput',false);
        end
    end
end

if aggregateDatasetResults
    % Go over each field and aggregate the data over different datasets. Only
    % the celltype variation is present
    datasets=fieldnames(variablesForPlot);
    measures=fieldnames(variablesForPlot.(datasets{1}));
   
    for i=1:length(measures)
        curData={};
        for j=1:length(datasets)
        curData=[curData;variablesForPlot.(datasets{j}).(measures{i})];
        end
        cellTypeNr=size(curData,2);
        for cellType=1:cellTypeNr
            aggData{cellType}=cat(1,curData{:,cellType});
        end
        variablesForPlot.All.(measures{i})=aggData;
    end
    variablesForPlot=variablesForPlot.All;
end
end

