function [count] = getSynapseCountInh()
% getSynapseCountInh Get the synapse count for inhibitoryAxons

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
apTuft=apicalTuft.getObjects('inhibitoryAxon');
synCount=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');
count.layer2=synCount{1,5}{1}{:,2:end};
count.deep=synCount{2,5}{1}{:,2:end};
end

