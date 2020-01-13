function [skel] = replaceCommentWithIdx...
    (skel,treeIndices,nodeIdx,rep, comment, repMode)
% replaces comments at specific nodeIds, if complete replacement the old
% comment string is not necessary to be given
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% replace part taken from replaceComments in the skeleton class
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

if ~exist('repMode', 'var') || isempty(repMode)
    repMode = 'complete';
end

for i = 1:length(treeIndices)
    for j = 1:length(nodeIdx{i})
        switch repMode
            case 'complete'
                skel.nodesAsStruct{treeIndices(i)}(nodeIdx{i}(j)). ...
                    comment = rep;
            case 'partial'
                skel.nodesAsStruct{treeIndices(i)}(nodeIdx{i}(j)). ...
                    comment = ...
                    strrep(skel.nodesAsStruct{treeIndices(i)} ...
                    (nodeIdx{i}(j)).comment, comment, rep);
            otherwise
                error('Unknown replacement mode %s.', repMode)
        end
    end
end
end

