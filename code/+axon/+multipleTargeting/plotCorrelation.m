function [] = plotCorrelation(ratioMinusSeed)
%PLOTCORRELATION plots correlation between number of times an axon targets
%its seed apical dendrite and the fraction of other synapse it makes onto
%that apical type(minus the seed synapses)
c=util.plot.getColors;
seedTag={'l2Idx','dlIdx'};
targetTag={'L2Apical','DeepApical'};
colorTag={'l2color','dlcolor'};
for seedT=1:length(seedTag)
    figure('Name',['Seed type:',seedTag{seedT}])
    hold on
    for targetT=1:length(targetTag)
        scatter(ratioMinusSeed.seedTargeting.(seedTag{seedT}).seedTargetingNr,...
            ratioMinusSeed.(seedTag{seedT}).(targetTag{targetT}),...
            [],c.(colorTag{targetT}))
    end
    xlabel('Number of times seed is targeted');
    ylabel('Fraction of synapses onto L2(grey) and Deep(orange) apicals');
    xlim([0.5,6.5]);ylim([0,1])
    hold off
end
end

