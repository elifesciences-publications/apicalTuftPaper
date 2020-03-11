function [] = pairwiseIntersection(groups)
%PAIRWISEINTERSECTION This is to make sure that there's no overlap between
% groups of different kind(synapses or trees)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
for firstSynSet = 1:length(groups)
    for secondSynSet = firstSynSet+1:length(groups)
        assert(isempty(intersect(groups{firstSynSet},...
            groups{secondSynSet})),'Synapse groups overlap');
    end
end
end

