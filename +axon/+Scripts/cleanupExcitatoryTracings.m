skel=apicalTuft('PPC_Axons_excitatory_olderTracing');
skel=skel.replaceSynTags([],skel.syn,...
    ["sp","sh","sp (back)","sp (neck)","soma"]);
skel.write('PPC_Axons_excitatory_olderTracing_corrected')

%% remove extra trees from the excitatory tracings

settingJsonForExcitatory={'V2_Axons_excitatory',...
    'PPC_Axons_excitatory','ACC_Axons_excitatory'};
for dataset=1:length(settingJsonForExcitatory)
    skel{dataset}=apicalTuft(settingJsonForExcitatory{dataset});
end

for dataset=1:length(settingJsonForExcitatory)
    skel{dataset}.write(skel{dataset}.filename,...
        [skel{dataset}.l2Idx;skel{dataset}.dlIdx])
end
%% Get unique comments
settingJsonForExcitatory={'V2_Axons_excitatory',...
    'PPC_Axons_excitatory','ACC_Axons_excitatory'};
allUniqueComments=axon.datasetFun('getAllComments',settingJsonForExcitatory,false);
allUniqueComments=cellfun(@unique,allUniqueComments,'UniformOutput',false);
for dataset=1:3
    writetable(cell2table(allUniqueComments{dataset}),...
        fullfile(axon.dir,'excitatoryAxons','uniqueComments',...
        [settingJsonForExcitatory{dataset},'_uniqueComments.txt']),'Delimiter',' ')
end