function obj = reformatSynComments(obj,treeIndices,strings,method)
% replace old comments
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('strings','var') || isempty(strings)
    strings = ["L2Apical","DeepApical","Soma","Shaft",...
        "SpineDouble","SpineSingle","AIS","Glia"];
end
if ~exist('method','var') || isempty(method)
    method = 'append';
end
synapseNodes = obj.getSynIdx(treeIndices);

for tr = 1:length(treeIndices)
    for synType = 2:size(synapseNodes,2)
        for nodeId= 1:length(synapseNodes{tr,synType}{1})
            oldComment = obj.nodesAsStruct{treeIndices(tr)}...
                (synapseNodes{tr,synType}{1}(nodeId)).comment;
            switch method
                case 'append'
                    newComment = [strings{synType-1},'_',oldComment];
                    obj.nodesAsStruct{treeIndices(tr)}...
                        (synapseNodes{tr,synType}{1}(nodeId)).comment = ...
                        newComment;
                case 'replace'
                    obj.nodesAsStruct{treeIndices(tr)}...
                        (synapseNodes{tr,synType}{1}(nodeId)).comment = ...
                        strings{synType-1};
                otherwise
                    error ('Method of comment replacement problematic')
            end
        end
    end
end

end
