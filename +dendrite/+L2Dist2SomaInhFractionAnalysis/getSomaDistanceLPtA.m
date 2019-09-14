function [somaDistance] = getSomaDistanceLPtA(thisSkel)
%GETSOMADISTANCELPTA Get the distance between the stem of each branch and
% soma using 'highres edge_xx' comment
trIndices=thisSkel.groupingVariable.layer2ApicalDendrite_dist2soma{1};
cc=1;
for i=1:length(trIndices)
    tr=trIndices(i);
    curCommentIdx=thisSkel.getNodesWithComment('highres edge',tr,'partial');
    for j=1:length(curCommentIdx)
        somaDistance (cc) = ...
            thisSkel.getSomaDistance(tr,sprintf('highres edge_%0.2u',j)). ...
            distance2Soma{1};
        trName {cc}=sprintf('layer2ApicalDendrite_mapping%0.2u_%0.2u',tr,j);
        cc=cc+1;
    end
end
trName=trName';
% Name order matches between mapping and distance 2 soma
assert(isequal(trName,...
    thisSkel.names(thisSkel.groupingVariable.layer2ApicalDendrite_mapping{1})))
% Output a simple array
somaDistance = somaDistance';
end

