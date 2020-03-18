function writeSynLocationAsTree(skel,randomSynapses,names,outputDir)
% Outdated function for getting a random sample of synapses from main
% bifurcation annotations in S1, V2, PPC and ACC datsets
% Only kept for back reference
%Author: Ali Karimi<ali.karimi@brain.mpg.de>
apicalTypeString={'layer2','deep'};
for dataset=1:4
    for apicalType=1:2
        for tree=1:height(randomSynapses{apicalType,dataset})
            for synapseType=2:3
                %Add an increment so that the two trees are distinguishable
                curCoord=randomSynapses{apicalType,dataset}{tree,synapseType}{1};
                curCoordFirst=curCoord+1;
                curCoordSecond=curCoord+2;
                %Create the names
                synType=randomSynapses...
                    {apicalType,dataset}.Properties.VariableNames{synapseType};
                currApicalType=apicalTypeString{apicalType};
                treeNamesFirst=[synType,'_',currApicalType,'_',sprintf('%0.2u',2*tree-1)];
                treeNamesSecond=[synType,'_',currApicalType,'_',sprintf('%0.2u',2*tree)];
                %add them to the skeleton
                skel{dataset}=skel{dataset}.addTree(treeNamesFirst,curCoordFirst,[],[1 0 0 1]);
                skel{dataset}=skel{dataset}.addTree(treeNamesSecond,curCoordSecond,[],[0 0 1 1]);
            end
        end
    end
    skel{dataset}.write(fullfile(outputDir,...
        ['synSizeComparison_' names{dataset}]));
end
end

