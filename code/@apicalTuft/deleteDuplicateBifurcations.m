function [skels] = deleteDuplicateBifurcations(skels)
% deleteDuplicateBifurcations delete bifurcation tracings that were used as
% starting point for whole dendrite tracing
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% S1
exclude{1}={'deepLayerApicalDendrite10','deepLayerApicalDendrite09',...
    'layer2ApicalDendrite09','layer2ApicalDendrite08'};
% V2
exclude{2}={'deepLayerApicalDendrite09','deepLayerApicalDendrite08',...
    'layer2ApicalDendrite07','layer2ApicalDendrite10'};
% PPC
exclude{3}={'deepLayerApicalDendrite09','layer2ApicalDendrite07'};
% ACC
exclude{4}={};
if istable(skels)
    skels=table2cell(skels);
end
for i=1:length(skels)
    lengthBeforeDeleting=length(skels{i}.names);
    for j=1:length(exclude{i})
        % Delete the tree to be excluded
        skels{i}=skels{i}.deleteTreeWithName(exclude{i}{j},'exact');
    end
    
    assert(lengthBeforeDeleting == length(skels{i}.names)+length(exclude{i}))
end    
end

