function [tableOfSeedTargetingNr] = getSeedTargetingNumber(skel,treeIndices)
% Gets the number of times a seed target is hit.
% INPUT: skel, treeIndices
% OUTPUT:
%       tableOfSeedTargetingNr:
%       table containing the seedTargeting number and weight
%       (1 / seedTargeting number) for each tree
%    Note: You need a regular expression of the type "seed String + number"
%    with number representing the number of times seed is targeted. e.g.
%    "seed 5" represents a seed that is targeted 5 times.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end

treeIndices = treeIndices(:)';
seedIdx = skel.getNodesWithComment(skel.seed,treeIndices,'partial');
assert(all(cellfun(@length,seedIdx) == 1),'Seed uniqueness check')
targetNrFinder = @(tr,seedIdx) regexp(skel.nodesAsStruct{tr}(seedIdx).comment,...
    [char(skel.seed),' (\d)'],'tokens');
stringOfNrSeed = cellfun(targetNrFinder,num2cell(treeIndices)',...
    seedIdx,'UniformOutput', false);
numberOfTargeting = arrayfun(@(x) str2double(stringOfNrSeed{x,1}{1}),...
    1:length(stringOfNrSeed));
assert(all(numberOfTargeting>=1), 'Seed targeted at least once');
tableOfSeedTargetingNr = table(skel.treeUniqueString(treeIndices'),...
    numberOfTargeting',1./numberOfTargeting',...
    'VariableNames',{'treeIndex','seedTargetingNr','weight'});

end

