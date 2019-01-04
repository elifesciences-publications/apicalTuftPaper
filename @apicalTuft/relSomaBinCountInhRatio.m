function [skel] = relSomaBinCountInhRatio(skel,...
    treeIndices,range)
% relSomaBinCountInhRatio

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
if ~exist('range','var') || isempty(range)
    range=0:10:200;
end
threshSynNum=5;
assert(~isempty(skel.distSoma.synDistance2Soma))
skel.distSoma.synBinCountRelSoma=...
    skel.createEmptyTable(treeIndices,[],'cell');
skel.distSoma.inhRatioRelSoma=...
    skel.createEmptyTable(treeIndices,{'treeIdx','inhRatio'},'cell');
skel.distSoma.acceptableInhRatios=...
    skel.createEmptyTable(treeIndices,...
    {'treeIdx','acceptableRatios'},'cell');
for tr=treeIndices(:)'
    for sy=2:width(skel.distSoma.synDistance2Soma)
        skel.distSoma.synBinCountRelSoma{tr,sy}{1}=...
            histcounts(skel.distSoma.synDistance2Soma{tr,sy}{1},range);
    end
    inh=skel.distSoma.synBinCountRelSoma{tr,'Shaft'}{1};
    exc=skel.distSoma.synBinCountRelSoma{tr,'Spine'}{1};
    acceptableRatios=(inh+exc)>threshSynNum;
    skel.distSoma.inhRatioRelSoma{tr,2}{1}=...
        inh./(inh+exc);
    skel.distSoma.acceptableInhRatios{tr,2}{1}=...
        inh./(inh+exc);
    skel.distSoma.acceptableInhRatios{tr,2}{1}(~acceptableRatios)=...
        nan;
end
end

