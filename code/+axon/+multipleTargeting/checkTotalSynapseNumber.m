function [] = checkTotalSynapseNumber(skel,MultiPerDataset,results)
% checkTotalSynapseNumber: check that the total number of synapse in the
% apical dendrite group is the same before and after extraction of multiple
% innervation

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

seedTag = {'l2Idx','dlIdx'};
for d = 1:length(skel)
    for seedT = 1:2
        trIndices = skel{d}.(seedTag{seedT});
        % synCount has all synapses except the first seed synapse
        curCount = skel{d}.getSynCount(trIndices);
        curCountSum = sum(curCount{:,2:3},1);
        seedCounts = MultiPerDataset{d}.seedTargetingNr(trIndices,:);
        % Take out the first seed synapse (also excluded in getSynCount method)
        seedCounts(:,seedT) = seedCounts(:,seedT)-1;
        % Sum over trees of the same seed type
        additionalSeedCount = sum(seedCounts,1);
        % Get the count of all non-seed synapses. Note that to get the
        % total number of synapses, the number of targets should be multiplied by the
        % number of synapses on each target.
        allNonSeedSyn = sum(results{d}(:,:,seedT).*[1:10]',[1,3]);
        % count check between the two counts
        assert(all(curCountSum == ...
        (allNonSeedSyn + additionalSeedCount)), 'Count per AD type Check failed')
    end
end
end

