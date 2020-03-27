function strings = treeUniqueString(obj,treeIndices)
% treeUniqueString: Returns the a unique TableID which consists of the
% NML file name, tree name and tree Index.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end

strings = cell(length(treeIndices),1);
cc = 1;
for tr = treeIndices(:)'
    strings{cc} = [obj.filename,'_',obj.names{tr},...
        '_',num2str(tr,'%0.3u')];
    cc = cc+1;
end
end
