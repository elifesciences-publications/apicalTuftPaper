%% Get the old synapse node Idx for checking later
% Let's start with V2,PPC and ACC, S1 commenting scheme is different
% because of comment similarity
for dataset = 2:4
    identifier = apicalTuft.config.inhibitoryAxon{dataset};
    skel{dataset} = apicalTuft(identifier,identifier);
    synIdx{dataset} = skel{dataset}.getSynIdx;
end
save('/home/alik/code/alik/L1paper/+axon/data/synIdxBeforeCleanup.mat','synIdx');
%% First create a merger of the old and new comments/stringNames
% Then switch to replacing
newNameStrings.layer2 = 'inhibitoryAxonLayer2ApicalDendriteSeeded';
newNameStrings.deep = 'inhibitoryAxonDeepLayerApicalDendriteSeeded';
newComments = axon.clean.getNewComments;
bifurcationTags = {'inBIFAreaSameCell','inBIFAreaOtherCell'};
bifurcationReplacement = {'bifurcationSameApical','bifurcationOtherApical'};
for dataset = 1:4
    identifier = apicalTuft.nmlName.inhibitoryAxon{dataset};
    skel{dataset} = apicalTuft(identifier,identifier);
    % Get the bifurcation node indices for later tag addition
    bifurcationNodeIdx{1} = skel{dataset}.getNodesWithComment(...
        bifurcationTags{1},[],'partial');
    bifurcationNodeIdx{2} = skel{dataset}.getNodesWithComment(...
        bifurcationTags{2},[],'partial');
    % Replace comments and the treeNames
    skel{dataset} = skel{dataset}.reformatApicalTreeNames...
        ([],newNameStrings,'replace');
    skel{dataset} = skel{dataset}.reformatSynComments...
        ([],newComments{dataset},'replace');
    
    % Add the bifurcation tag for weighting
    % Check to see if the seed targeting number from Seed x and the
    % comments match
    seedFromSeed = skel{dataset}.getSeedTargetingNumber;
    
    numebrOfBifComments = cellfun(@(x)cellfun(@length,x),bifurcationNodeIdx,...
        'UniformOutput',false);
    seedTargeting = cat(2,numebrOfBifComments{:});
    seedTargeting = sum(seedTargeting,2);
    if ~(isequal(seedTargeting+1,seedFromSeed.seedTargetingNr))
        skel{dataset}.names(find(seedTargeting+1 ~= ...
            seedFromSeed.seedTargetingNr));
    end
    % append the seed targeting information to each comment
    skel{dataset} = skel{dataset}.appendCommentWithIdx([],bifurcationNodeIdx{1}, ...
        bifurcationReplacement{1});
    skel{dataset} = skel{dataset}.appendCommentWithIdx([],bifurcationNodeIdx{2},...
        bifurcationReplacement{2});
    % replace the unsure and seed synapses with standard strings
    % seed is only partially replaced because it contains also the seed
    % targeting type information
    skel{dataset} = skel{dataset}.replaceCommentWithIdx([],skel{dataset}.getUnsureIdx,...
        'unsureSynapse',[],'complete');
    skel{dataset} = skel{dataset}.replaceCommentWithIdx([],skel{dataset}.getSeedIdx,...
        'seed',skel{dataset}.seed,'partial');
    switch dataset
        case 4
            % fix Dead end to"dead end" in ACC
            skel{dataset} = skel{dataset}.replaceComments( 'Dead end', 'dead end', 'exact', ...
                'complete');
        case 2
            skel{dataset} = skel{dataset}.replaceComments( 'jan', 'tracer: Jan', 'exact', ...
                'complete');
            skel{dataset} = skel{dataset}.replaceComments( 'ali', 'tracer: Ali', 'exact', ...
                'complete');
    end
    % Inspect unique comments
    uniqueComments{dataset} = skel{dataset}.getUniqueComments;
end
% Write them out
output = '/home/alik/code/alik/L1paper/NMLs/inhibitoryAxons';
for dataset = 1:4
    %skel{dataset}.write(apicalTuft.nmlName.inhibitoryAxon{dataset},output)
end
%% Save and then check the number of synapses before and after the tracing
% clean up is done

for dataset = 2:4
    skel{dataset} = apicalTuft(apicalTuft.nmlName.inhibitoryAxons{dataset});
    synCountAfter{dataset} = skel{dataset}.getSynCount;
    if ~(isequal(synCountAfter{dataset}{:,2:end},cellfun(@length,synIdx{dataset}{:,2:end})))
        offLocations{dataset} = synCountAfter{dataset}{:,2:end}-...
            cellfun(@length,synIdx{dataset}{:,2:end});
    end
 end
%% Check the trimming sanity

for dataset = 1:4
    skel{dataset} = apicalTuft(apicalTuft.nmlName.inhibitoryAxons{dataset});
    skeltrimmed{dataset} = skel{dataset}.getBackBone;
    skel{dataset}.plot([],[1,0,0]);
    skeltrimmed{dataset}.plot([],[0,0,1]);
end