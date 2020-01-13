%% Get the old synapse node Idx for checking later
% We are doing this for excitatory axons from V2, PPC, ACC and LPtA. In
% addition to inhibitory axons from LPtA. These tracings are all only for
% mapping their spine targeting ratio only and not specificity
for dataset=1:5
    identifier=apicalTuft.nmlName.axonsShaftRatioMapping{dataset};
    skel{dataset}=apicalTuft(identifier,identifier);
    synCount{dataset}=skel{dataset}.getSynCount;
end
save('/home/alik/code/alik/L1paper/+axon/data/synCountCleanup_spineRatioMapping.mat','synCount');
%% Clean up
% The idea is to first append the new version of comment and the treename
% to the old version and inspect the unique names and then go ahead and
% replace them
newNameStrings.layer2 = 'layer2ApicalDendriteSeeded';
newNameStrings.deep = 'deepLayerApicalDendriteSeeded';
newComments={'spine_singleInnervaterd','shaft','spine_DoubleInnervaterd','spine_neck',...
    'cellBody'};
for dataset=1:5
    identifier=apicalTuft.nmlName.axonsShaftRatioMapping{dataset};
    skel{dataset}=apicalTuft(identifier,identifier);
    
    % treeNames
    skel{dataset}=skel{dataset}.reformatApicalTreeNames...
        ([],newNameStrings,'replace');
    
    % comments
    skel{dataset}=skel{dataset}.reformatSynComments...
        ([],newComments,'replace');
    % unsure and seed synapses
    skel{dataset}=skel{dataset}.replaceCommentWithIdx([],skel{dataset}.getUnsureIdx,...
        'unsureSynapse',[],'complete');
    skel{dataset}=skel{dataset}.replaceCommentWithIdx([],skel{dataset}.getSeedIdx,...
        'seed',skel{dataset}.seed,'complete');
    % some minor replacements
    skel{dataset}=skel{dataset}.replaceComments( 'Dead end', 'dead end', 'exact', ...
                'complete');
    % Inspect unique comments
    uniqueComments{dataset}=skel{dataset}.getUniqueComments;
end
% Write them out
outputDir='/home/alik/code/alik/L1paper/NMLs/spineRatioMapping/';
ouputNames={'V2_spineRatioMapping','PPC_spineRatioMapping',...
    'ACC_spineRatioMapping','LPtAExcitatory_spineRatioMapping',...
    'LPtAInhibitory_spineRatioMapping'};
for dataset=1:5
    skel{dataset}.write(ouputNames{dataset},outputDir)
end

%% Save and then check the number of synapses before and after the tracing
% clean up is done

for dataset=1:5
    skel{dataset}=apicalTuft(apicalTuft.nmlName.spineRatioMapping{dataset});
    synCountAfter{dataset}=skel{dataset}.getSynCount;
    if ~(isequal(synCountAfter{dataset}{:,2:end},synCount{dataset}{:,2:end}))
        offLocations{dataset}=synCountAfter{dataset}{:,2:end}-...
            synCount{dataset}{:,2:end};
    end
 end
