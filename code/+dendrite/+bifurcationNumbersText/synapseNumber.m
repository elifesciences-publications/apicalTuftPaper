% This script gives the total number of synapses of the main bifurcation
% annotations
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll
apTuft = apicalTuft.getObjects('bifurcation');
dendrite.getSynapseNumbers(apTuft);