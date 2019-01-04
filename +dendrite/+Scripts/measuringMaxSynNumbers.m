clear all
addpath(genpath('/home/alik/code/alik'));
%% figure 1c

run config.m
synCount=cell(2,5);
for dataset=1:4
    skel=skeleton(info.(names(dataset)).tenUm.nmlName);
    %Get the Ids of the trees
    l2Idx=skel.getTreeWithName(info.(names(dataset)).tenUm.type{1},'first');
    dlIdx=skel.getTreeWithName(info.(names(dataset)).tenUm.type{2},'first');
    
    %Get shaft synapse Ratio
    synCount{1,dataset}=skel.getSynCountComment(l2Idx,'inputAK',...
        info.(names{dataset}).tenUm);
    synCount{2,dataset}=skel.getSynCountComment(dlIdx,'inputAK',...
        info.(names{dataset}).tenUm);
    
end
synCount{1,5}=cat(1,synCount{1,1:4});
synCount{2,5}=cat(1,synCount{2,1:4});

