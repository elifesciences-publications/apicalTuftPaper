function skel = sortTreesByName( skel )
%SORTTREESBYID Sort the trees in a skeleton by their name.
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

[~,idx] = sort(skel.names);
skel = skel.reorderTrees(idx);
skel=skel.updateGrouping;
end