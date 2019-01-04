function [tableOfSeedTargetingNr] = getSeedTargetingNumber(skel,treeIndices)
% Gets the number of times a seed target is hit.
%    Note: You need a regular expression of the type "seedTag
%    NrofTargeting" such as "seed 5"
% INPUT: treeIndices
% OUTPUT: table containing the seedTargeting number and weight(1/seedTargeting number) for
% each tree
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end    
    treeIndices=treeIndices(:)';
    seedIdx=skel.getNodesWithComment(skel.seed,treeIndices,'partial');
    assert(all(cellfun(@length,seedIdx)==1),'Seed uniqueness check')
    targetNrFinder=@(tr,seedIdx) regexp(skel.nodesAsStruct{tr}(seedIdx).comment,...
        [char(skel.seed),' (\d)'],'tokens');
    rawNumberofTargeting=cellfun(targetNrFinder,num2cell(treeIndices)',...
        seedIdx,'UniformOutput', false);
    numberOfTargeting=arrayfun(@(x) str2double(rawNumberofTargeting{x,1}{1}),...
        1:length(rawNumberofTargeting));
   tableOfSeedTargetingNr=table(skel.treeUniqueString(treeIndices'),...
       numberOfTargeting',1./numberOfTargeting',...
       'VariableNames',{'treeIndex','seedTargetingNr','weight'});
   
end

