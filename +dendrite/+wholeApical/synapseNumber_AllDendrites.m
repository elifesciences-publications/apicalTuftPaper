% This script gives the total number of synapses when you put the whole
% apical dendrite and bifurcations together
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

util.clearAll

S1V2PPCACC_allDendrites=dendrite.wholeApical.mergeBifurcation_WholeApical(4);
LPtAPPC2=apicalTuft.getObjects('l2vsl3vsl5');

synCount{1}=dendrite.getSynapseNumbers(S1V2PPCACC_allDendrites);
synCount{2}=dendrite.getSynapseNumbers(LPtAPPC2);
synCount{1}.Variables=synCount.Aggre.Variables+synCount{2}.Variables;
disp(synCount{1})
disp(synCount{1}.Properties.VariableNames)
disp(synCount{1}('Aggregate',:).Variables+...
    synCount{2}('Aggregate',:).Variables)