function [skel] = reformatApicalTreeNames(skel, treeIndices,newNameStrings,method)
%REPLACETREENAME Summary of this function goes here
%   Detailed explanation goes here
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

% Set defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

if ~exist('method','var') || isempty(method)
    method = 'append';
end
if ~exist('newNameStrings','var') || isempty(newNameStrings)
    newNameStrings.layer2 = 'layer2ApicalDendrite';
    newNameStrings.deep = 'deepLayerApicalDendrite';
end
l2Counter = 1;
deepCounter = 1;
switch method
    case 'append'
        for tr = treeIndices(:)'
            if ismember(tr,skel.dlIdx)
                skel.names{tr} = sprintf('%s%0.2u_%s',...
                    newNameStrings.deep,deepCounter,skel.names{tr});
                deepCounter = deepCounter+1;
            elseif ismember(tr,skel.l2Idx)
                skel.names{tr} = sprintf('%s%0.2u_%s',...
                    newNameStrings.layer2,l2Counter,skel.names{tr});
                l2Counter = l2Counter+1;
            end
        end
    case 'replace'
        for tr = treeIndices(:)'
            if ismember(tr,skel.dlIdx)
                skel.names{tr} = sprintf('%s%0.2u',...
                    newNameStrings.deep,deepCounter);
                deepCounter = deepCounter+1;
            elseif ismember(tr,skel.l2Idx)
                skel.names{tr} = sprintf('%s%0.2u',...
                    newNameStrings.layer2,l2Counter);
                l2Counter = l2Counter+1;
            end
        end
    otherwise
        error('Method is not properly set')
end
end

