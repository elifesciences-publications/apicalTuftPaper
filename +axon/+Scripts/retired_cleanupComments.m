% append name of the target to the synapse tag
JsonNames=apicalTuft.config.inhibitoryAxon;
skel=axon.datasetFun('appendString2Syn',JsonNames,false);

for dataset=1:(length(skel)-1)
    skel{dataset}.write([JsonNames{dataset},'_synTypeAttachedAsComment'])
end

%%
s1cleaned=skel{1}.replaceComments('_Shaft_','_','partial','partial')
s1cleaned.write([JsonNames{1},'_synTypeAttachedAsComment'])