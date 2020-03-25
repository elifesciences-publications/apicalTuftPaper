% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Percent of inhibitory synapses at the main bifurcation. Used in the
% results text
util.clearAll
apTuft = apicalTuft.getObjects('bifurcation');
synRatio = apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getSynRatio');

percentInhibitory = cellfun(@(x) x{:,2}.*100,synRatio.Aggregate,...
    'UniformOutput',false);
Minimums = round(cellfun(@min,percentInhibitory),1);
Maximums = round(cellfun(@max,percentInhibitory),1);
Means = round(cellfun(@mean,percentInhibitory),1);
SDs = round(cellfun(@std,percentInhibitory),1);
allPercentResults = table(Minimums,Maximums,Means,SDs,...
    'RowNames',{'layer2','Deep'});
disp(allPercentResults)