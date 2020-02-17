% The total number of synapses in the whole apical dendrite group

ap=apicalTuft.getObjects('wholeApical');
l235=apicalTuft.getObjects('l2vsl3vsl5');
totalSynWholeApical=apicalTuft.applyMethod2ObjectArray(ap,'getTotalSynNumber',false);
totalSynL235=apicalTuft.applyMethod2ObjectArray(l235,'getTotalSynNumber',false);
disp('Total synapse number in the whole apical dendrite group')
disp(sum([totalSynWholeApical.Aggregate{1}{:,2};totalSynL235.LPtA{1}{:,2}]))