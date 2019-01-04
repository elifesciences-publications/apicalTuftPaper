function [obj] = removeAllGrouping(obj)
%REMOVEALLGROUPING resets all grouping and have all trees in the root group
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
obj.groupId = nan(obj.numTrees,1);
obj.groups = struct2table(struct('name', '', 'id', ...
    [], 'parent', []));
end

