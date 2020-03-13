function [groupedStrings] = outputTheGrouping(prop)
% outputTheGrouping outputs the grouping of comment strings for synapses.
% This is used for checking whether there's any errors in the grouping
% INPUT:
%       prop: output from any of the config files in code/+config
% OUTPUT:
%       groupedStrings: Table showing the synapse labels and their
%       corresponding strings used to detect synapses in the comments of
%       the NML file

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Only continue if the syngroups are not empty
if isempty(prop.synGroups)
    error('no synGroups defined for the input')
end
% Get the grouped strings
groupedStrings = cell(length(prop.synGroups),1);
for i=1:length(prop.synGroups)
    groupedStrings{i} = prop.syn(cell2mat(prop.synGroups{i}));
end
% Get single groups
allGrouped = cat(1,groupedStrings{:});
assert(length(unique(allGrouped))==length(allGrouped),'Non-unique strings');
singleSynapticGroups = setdiff(prop.syn,allGrouped,'stable');
% combine
groupedStrings = [groupedStrings;singleSynapticGroups];
% correct order of labels
% Note: the order in the apicalTuft.getSynIdx is based on the min in each
% synapse string group

% Here we get the order to match the syn labels by following the process
% above and the using the Idx to arrange the comment string groups
% accordingly
minIdxGroup = cellfun(@(x) min(cell2mat(x)),prop.synGroups);
allGroupIdx = cellfun(@cell2mat,prop.synGroups,'uni',0);
singleIdx = setdiff([1:length(prop.syn)]',cat(1,allGroupIdx{:}),'stable');
allIdx = [minIdxGroup;singleIdx];
[~,synapseStringOrder]=sort(allIdx);

groupedStrings = table(groupedStrings(synapseStringOrder), ...
    'VariableNames', {'TheSynapseGroups'}, ...
    'RowNames',prop.synLabel);
end

