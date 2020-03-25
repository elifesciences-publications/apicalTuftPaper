function [randomSynapses] = getRandomSynapses(synapseCoord,synPerTree)
% Outdated function for getting a random sample of synapses from main
% bifurcation annotations in S1, V2, PPC and ACC datsets
% Only kept for back reference

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

randomSynapses = synapseCoord(:,1:4);
for dataset = 1:4
    for apicalType = 1:2
        for tree = 1:height(synapseCoord{apicalType,dataset})
            for synapseType = 2:3
                curCoords = synapseCoord{apicalType,dataset}{tree,synapseType}{1};
                if size(curCoords,1)>1
                randomSynapses{apicalType,dataset}{tree,synapseType}{1} = ...
                    hiwi.datasample(curCoords,synPerTree);
                else
                    randomSynapses{apicalType,dataset}{tree,synapseType}{1} = curCoords;
                end    
            end
        end
    end
end

end

