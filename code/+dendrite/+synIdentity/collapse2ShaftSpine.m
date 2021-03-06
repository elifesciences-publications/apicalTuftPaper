function [newTable] = collapse2ShaftSpine(oldTable)
% collapse2ShaftSpine collapse the variable synapses (8 groups) into
% single-innervated spine vs. shaft groups

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
newTable = oldTable;
vars2Del = oldTable.Properties.VariableNames([2,3,5:end]);
vars2sum = oldTable.Properties.VariableNames([2:4,6:end]);
newTable.Spine = oldTable.SpineSinglePlusApicalSingle;
newTable.Shaft = sum(oldTable{:,vars2sum},2);
newTable = removevars(newTable,vars2Del);
% Only throw errors if difference is larger than 1e-6
assert(all( (sum(newTable{:,2:end},2)-sum(oldTable{:,2:end},2)) < 1e-6 ))
end

