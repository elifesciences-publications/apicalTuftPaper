function [identifier] = getTreeIdentifier(obj,treeIndices)
% GETTREEIDENTIFIER Generate unique identifier in the format:
% filename_treename_treeIndex
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(obj.nodes);
end
identifier=cell(length(treeIndices),1);
for i=1:length(treeIndices)
    tr=treeIndices(i);
    identifier{i}=[obj.names{tr}];
end
end

