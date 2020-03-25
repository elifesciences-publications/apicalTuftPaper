% It is important to note that the config files were consistently during
% each step. Therefore, this cannot be run without taking care of the
% tracings

%% Get the old results for checking later
for dataset = 1:4
    synCount{dataset} = skel{dataset}.getSynCount;
end
save('/home/alik/code/alik/L1paper/+bifurcation/synCountBeforeCleanup.mat','synCount');
%% First create a merger of the old and new comments/stringNames
% Then switch to replacing
newNameStrings.layer2 = 'layer2ApicalDendrite';
newNameStrings.deep = 'deepLayerApicalDendrite';

for dataset = 1:4
    %skel{dataset} = apicalTuft(apicalTuft.config.bifurcation{dataset});
    %skelTreesRenamed{dataset} = skel{dataset}.reformatTreeNames...
    %    ([],newNameStrings,'replace');
    skelCommentsAppended{dataset} = skelTreesRenamed{dataset}.reformatComments...
        ([],{'Shaft','spineSingleInnervated','spineDoubleInnervated','spineNeck'},'replace');
    % Inspect unique comments
    uniqueComments{dataset} = skelCommentsAppended{dataset}.getUniqueComments;
end
% Write them out
for dataset = 1:4
    skelCommentsAppended{dataset}.write(apicalTuft.config.bifurcation{dataset})
end
%% Save and then check the number of synapses before and after the tracing
% clean up is done

for dataset = 1:4
    skel{dataset} = apicalTuft(apicalTuft.config.bifurcation{dataset});
    synCountAfter{dataset} = skel{dataset}.getSynCount;
    assert(isequal(synCountAfter{dataset}{:,2:end},synCount{dataset}{:,2:end}))
end

%% Cleanup the unsure synapses
for dataset = 1:4
    skel{dataset} = apicalTuft(apicalTuft.nmlName.bifurcation{dataset});
    %skel{dataset} = skel{dataset}.replaceCommentWithIdx([],skel{dataset}.getUnsureIdx,...
     %   'unsureSynapse',[],'complete');
    
    % Inspect unique comments
    uniqueComments{dataset} = skel{dataset}.getUniqueComments;
end
% Write them out
% for dataset = 1:4
%     skel{dataset}.write(apicalTuft.nmlName.bifurcation{dataset})
% end