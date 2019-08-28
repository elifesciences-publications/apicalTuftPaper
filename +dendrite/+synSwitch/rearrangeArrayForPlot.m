function [variablesForPlot] = rearrangeArrayForPlot(results,...
    layerOriginOrDataset,variables)
%REARRANGEARRAYFORPLOT rearranges tables with all the data to pick specific
%variables for plotting. This plotting variables contains structure with
%each one having a cell array inside for the cell type
% Note: results feilds should match layerOrigin
% Note: layerOriginOrDataset contains either dataset (bifur datasets) or
% layer of focus (main bifurcation or distalAd) in cellType datasets
for l=1:length(layerOriginOrDataset)
    curResults=results.(layerOriginOrDataset{l});
    indices=~cellfun(@isempty,curResults);
    for i=1:length(variables)
        variablesForPlot.(layerOriginOrDataset{l}).(variables{i})(indices)=...
            cellfun(@(x) x.(variables{i}),curResults(indices),...
            'UniformOutput',false);
    end
end

end

