function [skel] = replaceSynTags(skel,treeIndices,curTags,replaceTags)
%REPLACESYNTAGS this function replaces a certain set of synapse tags with another set
%INPUT: 
%       treeIndices
%       curTags: 1xN cell/string array. the current tag is replaced
%       replaceTags: 1xN cell/string array. the tags which replace the
%       Note: make sure the order in curTags and replaceTags match
% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || ~isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
assert (length(curTags) == length(replaceTags),'not equal length')

for i=1:length(curTags)
    skel=skel.replaceComments( curTags{i}, replaceTags{i}, 'partial', ...
    'partial', treeIndices);
end


end

