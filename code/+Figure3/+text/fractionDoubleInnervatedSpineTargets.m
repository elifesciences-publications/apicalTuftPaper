% I think we reoported this in the reviewer response letter. The number we 
% are calculating is the fraction of double-innervated postsynaptic spine 
% targets of the inhibitory axons
util.clearAll
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Get the apicalSpecificity
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synCount = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');
synapseCount_Agg = cat(1,synCount.Aggregate{:});

fractionDouble = sum(synapseCount_Agg.SpineDouble)/...
    sum([synapseCount_Agg.SpineSingle;synapseCount_Agg.SpineDouble]);
disp(['Fraction of double innervated postsyn targets: ',...
    num2str(fractionDouble)])