function [axonSwitchFraction] = switchFactorl235()
%SWITCHFACTORL235 loads the synapse switching fraciton for the l235
%datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
variableNames = {'mainBifurcation','distalAD'};
axonSwitchFraction = dendrite.synIdentity.loadSwitchFraction;
axonSwitchFraction = fliplr(struct2table(axonSwitchFraction,'AsArray',true));
axonSwitchFraction.Properties.VariableNames=...
    variableNames;
end

