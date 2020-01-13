function [synapseSizes]=synapseSize()
% OUTPUT
%       synapseSizes: a 2x2x5 cell array with the following dimensions: synapseTypes,
%                     apicalType,dataset
names=["S1","V2","PPC","ACC"];
% Number of trees per apical type and synapse type =2*number of synapses
numberOfSyn=[10,10,10,11];
apicalTag={'layer2','deep'};
synTag={'Spine','Shaft'};
synapseSizes=cell(2,2,5);
for synType=1:2
    for apicaltype=1:2
        for dataset=1:4
            skel=apicalTuft([names{dataset},'_synapseSize']);
            curTreeIdx=skel.getTreeWithName...
                ([synTag{synType},'_',apicalTag{apicaltype}],'first');
            nrOfTrees=numberOfSyn(dataset)*2;
            assert(size(curTreeIdx,1)==nrOfTrees)
            nodeNrPerTree=cellfun(@(x)size(x,1),skel.nodes(curTreeIdx));

            assert(all(nodeNrPerTree==2),'some trees do not have size 2')
            curRawPathLength=skel.pathLength(curTreeIdx).pathLengthInMicron;
            sortedPathLength=sortrows([skel.names(curTreeIdx),num2cell(curRawPathLength)]);
            curSortedPathLength=cell2mat(sortedPathLength(:,2));
            curPathLength=reshape(curSortedPathLength,2,numberOfSyn(dataset));
            % Area of ellipse = (semi minor axis) x (semi major axis) x (pi)
            curPathLength=curPathLength./2;
            synapseSizes{apicaltype,synType,dataset}=(prod(curPathLength,1).*pi)';
        end
        synapseSizes{apicaltype,synType,5}=cat(1,synapseSizes{apicaltype,synType,1:4});
    end
end
end