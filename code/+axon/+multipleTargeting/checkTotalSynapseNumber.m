function [] = checkTotalSynapseNumber(skel,MultiPerDataset,results)
% check that the total number of synapse in the apical dendrite groups
% match with what we get from syncount
seedTag={'l2Idx','dlIdx'};
for d=1:length(skel)
    for seedT=1:2
        trIndices = skel{d}.(seedTag{seedT});
        synCount = skel{d}.getSynCount(trIndices);
        curSynCountSum = sum(synCount{:,2:3});
        seedCounts = MultiPerDataset{d}.seedTargetingNr(trIndices,:);
        seedCounts(:,seedT) = seedCounts(:,seedT)-1;
        additionalSeedSynapses = sum(seedCounts,1);
        allOtherSyn = sum(results{d}(:,:,seedT).*[1:10]',[1,3]);
        disp(seedTag{seedT});
        disp(curSynCountSum);
        disp((allOtherSyn+additionalSeedSynapses))
    end
end
end

