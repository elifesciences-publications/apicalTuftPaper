function [axonSwitchFraction] = switchFactorl235(variableNames)
%SWITCHFACTORL235 loads the synapse switching fraciton for the l235
%datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

m=matfile(fullfile(util.dir.getAnnotation,'matfiles',...
    'axonSwitchFraction.mat'));
axonSwitchFraction=m.axonSwitchFraction;
axonSwitchFraction=fliplr(struct2table(axonSwitchFraction,'AsArray',true));
axonSwitchFraction.Properties.VariableNames=...
    variableNames;
end

