function [synCenterIdx] = getSynCenterFromTPA( skel,treeIndices,synNodeIds)
%This function walks for one node along the tree to get the synapse center
% It would output the problem coordinate if it encounters a problem
%from a tree point annotation(TPA)
%   INPUT: tr: id of the tree
%           synNodeIds: column vector of TPA synapse nodes
%   OUTPUT: synCenterIdx: the nodeId list by walking for 1 edge along the
%   tree
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
synCenterIdx = cell(size(synNodeIds));
trCounter = 1;
for tr = treeIndices(:)'
    for synType = 1:size(synNodeIds,2)
        synCenterIdx{trCounter,synType} = ...
            find(skel.reachableNodes...
            (tr,synNodeIds{trCounter,synType},1,'exact_excl'));
        
        % If there's inconsistency in synapse numbers find the node with
        % problem
        if ~(size(synCenterIdx{trCounter,synType},1) == size(synNodeIds{trCounter,synType},1))
            disp('walking for 1 node created different number of synapses.debugging...')
            for i = 1:length(synNodeIds{trCounter,synType})
                nodeIdxNeightborsOfNodeI = find(skel.reachableNodes(tr,synNodeIds{trCounter,synType}(i),...
                    1,'exact_excl'));
                assert(length(nodeIdxNeightborsOfNodeI) == 1,...
                    ['Node: ',num2str(synNodeIds{trCounter,synType}(i)),', in coords: ',...
                    num2str(skel.nodes{trCounter}(synNodeIds{trCounter,synType}(i),1:3)),...
                    ', in nml: ',skel.filename,' ,has this many neighbors: '...
                    ,num2str(length(nodeIdxNeightborsOfNodeI))]);
            end
        end
    end
    trCounter = trCounter+1;
end
end

