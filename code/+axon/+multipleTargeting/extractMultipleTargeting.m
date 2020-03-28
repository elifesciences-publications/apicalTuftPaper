function [multiTable] = extractMultipleTargeting(skel)
% EXTRACTMULTIPLETARGETING extracts multiple targeting from the axons with a
% naming structure which associates each synapse with its targeting index
% INPUT: 
%       skel: The apicalTuft object
% OUTPUT:
%       targetMultiplicity: table
%           contains raw and processed multi innervation of apical
%           dendrites. The seed multi-innervation is also reported here.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Maximum number of synapses on a postsynaptic target
maxMultiplicity = 10;
% Get synapse Idx and number of times the seed type is targeted
synIdx = skel.getSynIdx;
synIdx.treeIndex = skel.treeUniqueString;
synCount = skel.getSynCount;
seedTargeting = skel.getSeedTargetingNumber;

% make seed targeting related to the seeding type
seedCount = zeros(skel.numTrees,2);
IdxSeedType = ismember(1:skel.numTrees,skel.dlIdx)+1;
seedCount(sub2ind(size(seedCount),...
    1:skel.numTrees, IdxSeedType)) = ...
    seedTargeting{:,'seedTargetingNr'};
assert(all(seedTargeting{:,'seedTargetingNr'} == sum(seedCount,2)),...
    'Check that order of the trees are not substituted')

% Initialize the table for multiInnervation results and set the seed
% targeting
apicalLabels = {'L2Apical','DeepApical','L2ApicalRaw','DeepApicalRaw'};
multiTable = skel.createEmptyTable([],...
    [synIdx.Properties.VariableNames(1),apicalLabels],'cell');
multiTable.seedTargetingNr = seedCount;

% Loop over individual trees
for tr = 1:height(synIdx)
    % Initialize
    curIdx = synIdx{tr,{'L2Apical','DeepApical'}};
    synTargetNumber = cell(1,2);
    curCount_noSeed = cell(1,2);
    for targetIdx = 1:2
        % Initialize to the maximum estimated multi-innervation
        synTargetNumber{targetIdx} = zeros(1,maxMultiplicity);
        curCount_noSeed{targetIdx} = zeros(1,maxMultiplicity);
        % Only continue if synapses exist in the target group, otherwise
        % leave as empty
        if ~isempty(curIdx{targetIdx})
            % Note: The number in the string represents the Id of the
            % number on the target. _1:first synapse, _2: second synapse,
            % _3 third synapse, so on. Seed synapses are separately noted
            % only synapse _2, _3 on the seed is annotated. The reason for
            % this complex approach was historical development.
            
            % Extract the Multi innervation annotations from the comment
            % strings. 
            curComments = ...
                {skel.nodesAsStruct{tr}(curIdx{targetIdx}).comment};
            splitfun = @(curComment) ...
                regexp(curComment,'^(\w*)_(\d)$','tokens');
            curParts = cellfun(splitfun,curComments);
            cellfun(@(curPart) assert(length(curPart) == 2,'Length check'),...
                curParts)
            numConvertfun = @(curPart) uint8(str2double(curPart{2}));
            synTargetNumber{targetIdx} = cellfun(numConvertfun,curParts)';
            % Use accumarray to create a counting array with the first
            % element being the number of the first synapses (_1) and so on
            curStringCount = accumarray(synTargetNumber{targetIdx},1);
            
            % 0 on seed targeting means that the axon is seeded from the
            % other AD type
            if seedCount(tr,targetIdx) > 0
                % Take out seed targeting and its multi innervation using
                % information in the seed comment
                curStringCount(1,1) = curStringCount(1,1)+1;
                seedTargetingCount = accumarray([1:seedCount(tr,targetIdx)]',...
                    1,size(curStringCount));
                curMinusSeed = ...
                    curStringCount - seedTargetingCount;
                assert(isequal(sort(curMinusSeed,'descend'),...
                    curMinusSeed), 'Non-ascending check');
            else
                curMinusSeed = curStringCount;
            end
            
            % Now count how many of different multiple innervation
            % exist from the annotation
            curCount_noSeed{targetIdx} = zeros(1,maxMultiplicity);
            % maxMultiplicity is used to create arrays of the same size for
            % adding later. Make sure this arbitarary number is not smaller
            % than the largest multiplicity
            assert(maxMultiplicity > length(curMinusSeed), 'Size check');
            % Start from the highest multi string
            for curMult = length(curMinusSeed):-1:1
                curCount_noSeed{targetIdx}(curMult) = curMinusSeed(curMult);
                curMinusSeed = curMinusSeed-...
                    curMinusSeed(curMult);
            end
            assert(all(curCount_noSeed{targetIdx} >= 0), ...
                'Positivity check');
            % In case the target type matches the seeding type an
            % additional synapse should be added (The initial seed synapse)
            seedPresence = uint8(seedCount(tr,targetIdx) > 0);
            totalCurCount = sum(...
                curCount_noSeed{targetIdx}.*(1:maxMultiplicity)) + ...
                seedCount(tr,targetIdx);
            assert(totalCurCount == length(curComments)+seedPresence, ...
                'total number check');
            % Another check: use data from Get syn Count
            % Note: synCount gives the number of synapses minus the first
            % seed synapse, for results saved here we have taken out all
            % seed synapses. Therefore curCount_noSeed has X synapses less
            % than the total synapses. X is the number of all synapses on
            % the seed Apical dendrite
            assert(totalCurCount == ...
                synCount{tr, targetIdx+1}+seedPresence,...
                'total number check getSynCount')
        end
    end
    
    % Assignments
    multiTable{tr,{'L2Apical','DeepApical'}}...
        = curCount_noSeed;
    multiTable{tr,{'L2ApicalRaw','DeepApicalRaw'}}...
        = synTargetNumber;
end
% Convert to double
multiTable.L2Apical = cell2mat(multiTable.L2Apical);
multiTable.DeepApical = cell2mat(multiTable.DeepApical);
end

