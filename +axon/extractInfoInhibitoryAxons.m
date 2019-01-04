function [synCount,synRatio,synDensityInfo]=extractInfoInhibitoryAxons()

%Directory to save unique comments
parentDir = '/home/alik/code/alik/L1paper/NMLs/Axons/inhibitoryAxons/';

%% getting pathlength/synRatio/SynDensity

synCount=axon.inhDatasetFun('getSynCount',true);
synRatio=axon.inhDatasetFun('getSynRatio',true);
synDensityInfo=axon.inhDatasetFun('getTreeFeatures',true);

allUniqueComments=axon.inhDatasetFun('getAllComments',false);
allUniqueComments=cellfun(@unique,allUniqueComments,'UniformOutput',false);
for dataset=1:4
    writetable(cell2table(allUniqueComments{dataset}),...
        fullfile(parentDir,'uniqueComments',...
        [num2str(dataset),'_uniqueComments.txt']),'Delimiter',' ')
end
% compare all the results order to make sure all tables are matching
apicalTuft.compareTwoTables(synCount{1,5},synRatio{1,5});
apicalTuft.compareTwoTables(synCount{2,5},synRatio{2,5});
apicalTuft.compareTwoTables(synRatio{1,5},synDensityInfo{1,5});
apicalTuft.compareTwoTables(synRatio{2,5},synDensityInfo{2,5});

end