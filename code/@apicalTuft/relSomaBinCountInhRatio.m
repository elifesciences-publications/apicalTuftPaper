function [skel] = relSomaBinCountInhRatio(skel,...
    treeIndices,range)
% relSomaBinCountInhRatio calculate the inhibitory ratio relative to soma 
% distance. Used for analysis in layer 2 pyramidal cells
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
if ~exist('range','var') || isempty(range)
    range = 0:10:200;
end
% Synapses from bins with less than the following threshhold were merged
% into the neighboring bins
threshSynNum = 4;

assert(~isempty(skel.distSoma.synDistance2Soma))
skel.distSoma.synBinCountRelSoma = ...
    skel.createEmptyTable(treeIndices,[],'cell');
skel.distSoma.inhRatioRelSoma = ...
    skel.createEmptyTable(treeIndices,{'treeIdx','inhRatio'},'cell');
skel.distSoma.acceptableInhRatios = ...
    skel.createEmptyTable(treeIndices,...
    {'treeIdx','acceptableRatios'},'cell');
totalExc = 0;
totalInh = 0;
for tr = treeIndices(:)'
    for sy = 2:width(skel.distSoma.synDistance2Soma)
        skel.distSoma.synBinCountRelSoma{tr,sy}{1} = ...
            histcounts(skel.distSoma.synDistance2Soma{tr,sy}{1},range);
    end
    inh = skel.distSoma.synBinCountRelSoma{tr,'Shaft'}{1};
    exc = skel.distSoma.synBinCountRelSoma{tr,'Spine'}{1};
    % Keep a copy of total synapse numbers for assertions later
    inhPre = inh;
    excPre = exc;
    lowSynNumberIntervals = (inh+exc)<threshSynNum & (inh+exc)>0;
    noSynInterval = (inh+exc)<1;
    assert(~any(lowSynNumberIntervals&noSynInterval));
    if ~isempty(lowSynNumberIntervals)
        smallIntervalIdx = find(lowSynNumberIntervals);
        synPresenceIdx = find(~noSynInterval);
        largeIntervalIdx = setdiff(synPresenceIdx,smallIntervalIdx);
        assert(~isempty(largeIntervalIdx),...
            'no synapse group has enough synapses');
        % Note: sometimes there are multiple bins with low synapse numbers groups on
        % the edges of the bins. We need to merge them all together
        for i = smallIntervalIdx(:)'
            j = 1;
            id2copy = [];
            while length(id2copy)<1
                curNeighbors = i+[-j,j];
                id2copy = intersect(curNeighbors,largeIntervalIdx);
                if j>1
                    disp('location with two bins low numbers');
                end
                j = j+1;
            end
            id2copy = intersect(curNeighbors,largeIntervalIdx);
            if(length(id2copy)>1)
                % Choose one of the neighbors at random
                id2copy = datasample(id2copy,1);
                disp...
                    ('low synapse number is sandwiched between high synapse numbers')
            end
            % copy synapses to the neighbor which have significant synapse
            % numbers
            inh(id2copy) = inh(id2copy)+inh(i);
            exc(id2copy) = exc(id2copy)+exc(i);
            % set the small interval to nan
            inh(i) = nan;
            exc(i) = nan;
        end
        assert(all([isnan(inh(smallIntervalIdx)),...
            isnan(exc(smallIntervalIdx))]));
        assert(nansum(exc) == sum(excPre)&&nansum(inh) == sum(inhPre));
        totalExc = totalExc + nansum(exc);
        totalInh = totalInh + nansum(inh);
        skel.distSoma.inhRatioRelSoma{tr,2}{1} = ...
            inh./(inh+exc);
        skel.distSoma.acceptableInhRatios{tr,2}{1} = ...
            inh./(inh+exc);
        skel.distSoma.acceptableInhRatios{tr,2}{1}(noSynInterval) = ...
            nan;
    end
end
skel.distSoma.total = totalExc+totalInh;
end

