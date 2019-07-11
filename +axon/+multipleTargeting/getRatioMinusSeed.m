function [ratioSynNoSeed] = getRatioMinusSeed(skel)
%GETRATIOMINUSSEED Summary of this function goes here
%   Detailed explanation goes here
typeTag={'l2Idx','dlIdx'};
synTypeTag={'L2Apical','DeepApical'};
for type=1:length(typeTag)
    ratioSynNoSeed.seedTargeting.(typeTag{type})=...
        skel.getSeedTargetingNumber(skel.(typeTag{type}));
    seedTargeting=...
        ratioSynNoSeed.seedTargeting.(typeTag{type}).seedTargetingNr-1;
    
    allTargeting=skel.getSynCount(skel.(typeTag{type}));
    allTargeting.(synTypeTag{type})=...
        allTargeting.(synTypeTag{type})-seedTargeting;
    
    ratioSynNoSeed.(typeTag{type})=...
        skel.createEmptyTable(skel.(typeTag{type}),[],'double');
    ratioSynNoSeed.(typeTag{type}){:,2:end}=...
        allTargeting{:,2:end}./sum(allTargeting{:,2:end},2);
end
end

