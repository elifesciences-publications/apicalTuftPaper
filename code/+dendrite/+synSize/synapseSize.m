function [synapseSizes] = synapseSize()
% synapseSize: Returns the size of synapses measured using two edges on a
% synptic density area. Synapses are onto shaft and spine of L2 and Deep
% apical dendrites.
% OUTPUT
%       synapseSizes: a 2x2x5 cell array with the dimensions representing:
%                     apicalType, synapseTypes, [datasets(4X), aggregate]

% Author: Ali Karimi <ali.karimi@brain.mpg.de>


% Each synapse is measured using 2 edges.
% There are 41 synapses per group since we sampled 1 synapse per tree from
% the main bifurcation annotations (Fig.1) and each apical type had 41
% annotations
names = ["S1","V2","PPC","ACC"];
numberOfSyn = [10,10,10,11];
apicalTag = {'layer2','deep'};
synTag = {'Spine','Shaft'};
synapseSizes = cell(2,2,5);

for synType = 1:2
    for apicaltype = 1:2
        for dataset = 1:4
            % Read apicalTuft object
            skel = apicalTuft([names{dataset},'_synapseSize']);
            % Get the tree Indices
            curTreeIdx = skel.getTreeWithName...
                ([synTag{synType},'_',apicalTag{apicaltype}],'first');
            % Checks
            % Each synapse size is calculated by 2 edges (each a separate
            % tree)
            nrOfTrees = numberOfSyn(dataset)*2;
            assert(size(curTreeIdx,1) == nrOfTrees)
            nodeNrPerTree = cellfun(@(x)size(x,1),skel.nodes(curTreeIdx));
            assert(all(nodeNrPerTree == 2),'some trees do not have size 2');
            % Get the path length of each edge (axis length of synapse)
            % Each two sequantial tree are synaptic size measurement from
            % one synapse so they are grouped as follows: [01,02],
            % [03,04],...
            curRawPathLength = ...
                skel.pathLength(curTreeIdx).pathLengthInMicron;
            sortedPathLength = ...
                sortrows([skel.names(curTreeIdx),...
                num2cell(curRawPathLength)],1);
            curSortedPathLength = cell2mat(sortedPathLength(:,2));
            curPathLength = ...
                reshape(curSortedPathLength,2,numberOfSyn(dataset));
            % Now get half of the diameter (semi-axis length)
            curPathLength = ...
                curPathLength./2;
            % Use ellipse approcimationArea of ellipse  =  
            % (semi minor axis) x (semi major axis) x (pi)
            synapseSizes{apicaltype, synType, dataset} = ...
                (prod(curPathLength,1).*pi)';
        end
        synapseSizes{apicaltype,synType,5} = ...
            cat(1,synapseSizes{apicaltype,synType,1:4});
    end
end
end