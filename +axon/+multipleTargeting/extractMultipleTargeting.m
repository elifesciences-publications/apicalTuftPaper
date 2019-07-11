function [targetMultiplicity] = extractMultipleTargeting(skel)
%EXTRACTMULTIPLETARGETING extracts multiple targeting from the axons with a
% naming structure which associates each synapse with its targeting index
maxMultiplicity=10;
synIdx=skel.getSynIdx;synIdx.treeIndex=skel.treeUniqueString;
seedTargeting=skel.getSeedTargetingNumber;
% This table saves the target order of the synaps
% (1: first synapse on target,2: second synapse on target, so on)
apicalLabels={'L2Apical','DeepApical','L2ApicalRaw','DeepApicalRaw'};
targetMultiplicity=skel.createEmptyTable([],...
    [synIdx.Properties.VariableNames(1),apicalLabels],'cell');
targetMultiplicity=[targetMultiplicity,seedTargeting(:,'seedTargetingNr')];
% make seed targeting related to the seeding type
seedTargetingNr=zeros(skel.numTrees,2);
IdxSeedType=ismember(1:skel.numTrees,skel.dlIdx)+1;
seedTargetingNr(sub2ind(size(seedTargetingNr),...
    1:skel.numTrees,IdxSeedType))=...
    seedTargeting{:,'seedTargetingNr'};
targetMultiplicity.seedTargetingNr=seedTargetingNr;
for tr=1:height(synIdx)
    % Init
    curIdx=synIdx{tr,apicalLabels(1:2)};
    synTargetNumber=cell(1,2);
    curTargetCount=cell(1,2);
    for ap=1:2
        % More initialization
        synTargetNumber{ap}=zeros(1,maxMultiplicity);
        curTargetCount{ap}=zeros(1,maxMultiplicity);
        if ~isempty(curIdx{ap})
            curComment={skel.nodesAsStruct{tr}(curIdx{ap}).comment};
            splitfun=@(curComment) ...
                regexp(curComment,'^(\w*)_(\d)$','tokens');
            curParts=cellfun(splitfun,curComment);
            cellfun(@(curPart) assert(length(curPart)==2),curParts)
            numfun=@(curPart) uint8(str2double(curPart{2}));
            synTargetNumber{ap}=cellfun(numfun,curParts)';
            % Find the number of each targeting
            curRawCount=accumarray(synTargetNumber{ap},1);
            % Take out seed targeting in case of looking at the seed
            % targeet type innervation
            % Note seed targeting does not include the first synapse
            % since it is called seed X
            if seedTargetingNr(tr,ap) >0
                curRawCount(1,1)=curRawCount(1,1)+1;
                seedTargetingCount=accumarray([1:seedTargetingNr(tr,ap)]',...
                    1,size(curRawCount));
                curRawCountMinusSeed=...
                    curRawCount-seedTargetingCount;
                assert(isequal(sort(curRawCountMinusSeed,'descend'),...
                    curRawCountMinusSeed));
            else
                curRawCountMinusSeed=curRawCount;
            end
            % Now count how many of different multiple innervation
            % exist from the annotation
            curTargetCount{ap}=zeros(1,maxMultiplicity);
            % maxMultiplicity is used to create arrays of the same size for
            % adding later. Make sure this arbitarary number is not smaller
            % than the largest multiplicity
            assert(maxMultiplicity>length(curRawCountMinusSeed));
            for curMult=length(curRawCountMinusSeed):-1:1
                curTargetCount{ap}(curMult)=curRawCountMinusSeed(curMult);
                curRawCountMinusSeed=curRawCountMinusSeed-...
                    curRawCountMinusSeed(curMult);
            end
            assert(all(curTargetCount{ap}>=0));
            % Total synapses=seed synapses + non-seed synapses
            if seedTargetingNr(tr,ap) >0
                assert(sum(curTargetCount{ap}.*(1:maxMultiplicity))+...
                    seedTargetingNr(tr,ap)==length(curComment)+1)
            else
                assert(sum(curTargetCount{ap}.*(1:maxMultiplicity))+...
                    seedTargetingNr(tr,ap)==length(curComment))
            end
        end
    end
    targetMultiplicity{tr,{'L2Apical','DeepApical'}}...
        =curTargetCount;
    targetMultiplicity{tr,{'L2ApicalRaw','DeepApicalRaw'}}...
        =synTargetNumber;
end
% switch to double
targetMultiplicity.L2Apical=cell2mat(targetMultiplicity.L2Apical);
targetMultiplicity.DeepApical=cell2mat(targetMultiplicity.DeepApical);
end

