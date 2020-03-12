function [] = pairwiseIntersection(groups)
% pairwiseIntersection make sure that the group IDs does not overlap for
% the input
% INPUT:
%       groups: Idx of trees/synapses
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

for firstSynSet = 1:length(groups)
    for secondSynSet = firstSynSet+1:length(groups)
        assert(isempty(intersect(groups{firstSynSet},...
            groups{secondSynSet})),'Groups overlap');
    end
end
end

