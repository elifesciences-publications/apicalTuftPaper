%% Convert to only whole apical dendrite tracing
treeTag={'wT','10u','10u','10u','wholeTree'};
complement={true,false,false,false,true};
sizeOfWholeTrees=[4,4,4,6,8];
for d=1:5
    identifier=apicalTuft.nmlName.wholeApical{d};
    skel{d}=apicalTuft(identifier);
    trees2del=skel{d}.getTreeWithName(treeTag{d},'partial');
    skel{d}=skel{d}.deleteTrees(trees2del,complement{d});
    % match the number of whole trees to expectation
    assert (skel{d}.numTrees==sizeOfWholeTrees(d));
    disp(skel{d}.names)
end
% Write them out
for d=1:5
    skel{d}.write(apicalTuft.nmlName.wholeApical{d},...
        '/home/alik/code/alik/L1paper/NMLs/wholeApical')
end
%% Clean up
% The idea is to first append the new version of comment and the treename
% to the old version and inspect the unique names and then go ahead and
% replace them
newNameStrings.layer2 = 'layer2ApicalDendrite_whole';
newNameStrings.deep = 'deepLayerApicalDendrite_whole';
newComments={'Shaft','spineSingleInnervated','spineDoubleInnervated',...
    'spineNeck'};
oldL2Names={'L2'};
oldDeepNames={'Deep','deep','L5'};
for d=1:5
    identifier=apicalTuft.nmlName.wholeApical{d};
    skel{d}=apicalTuft(identifier);
    skel{d}.l2Idx=skel{d}.getTreeWithName(oldL2Names{1},'partial');
    curDLIdx=[];
    for dl=1:3
        thisIdx=skel{d}.getTreeWithName(oldDeepNames{dl},'partial');
        if ~isempty(thisIdx)
            % Here's the problem
        curDLIdx=[curDLIdx,];
        end
    end
    skel{d}.dlIdx=curDLIdx;
    % treeNames
    skel{d}=skel{d}.reformatApicalTreeNames...
        ([],newNameStrings,'replace');
    % Same for all datasets
    skel{d}.syn={'sh','sp', 'dual head', 'dual neck'};
    
    skel{d}.synExclusion={'unsure'};
    % comments
    skel{d}=skel{d}.reformatSynComments...
        ([],newComments,'replace');
    % unsure and seed synapses
    skel{d}=skel{d}.replaceCommentWithIdx([],skel{d}.getUnsureIdx,...
        'unsureSynapse',[],'complete');
    

    % Inspect unique comments
    uniqueComments{d}=skel{d}.getUniqueComments;
end
% Write them out
outputDir='/home/alik/code/alik/L1paper/NMLs/wholeApical/';

for d=1:5
      skel{d}.write(apicalTuft.nmlName.wholeApical{d},...
    outputDir)
end

%% Cleanup error: the treenames of the deep group was not corrected
newNameStrings.layer2 = 'layer2ApicalDendrite_whole';
newNameStrings.deep = 'deepLayerApicalDendrite_whole';
oldL2Names={'layer2ApicalDendrite_whole'};
oldDeepNames={'Deep','deep','L5'};
for d=1:5
    skel{d}=apicalTuft(apicalTuft.nmlName.wholeApical{d});
    skel{d}.l2Idx=skel{d}.getTreeWithName(oldL2Names{1},'partial');
    curDLIdx=[];
    for dl=1:3
        thisIdx=skel{d}.getTreeWithName(oldDeepNames{dl},'partial');
        if ~isempty(thisIdx)
            % Here's the problem
        curDLIdx=[curDLIdx,thisIdx];
        end
    end
    skel{d}.dlIdx=curDLIdx;
    % treeNames
    skel{d}=skel{d}.reformatApicalTreeNames...
        ([],newNameStrings,'replace');
    skel{d}.updateL2DLIdx;
end

% Write them out

for d=1:5
      skel{d}.write(apicalTuft.nmlName.wholeApical{d})
end