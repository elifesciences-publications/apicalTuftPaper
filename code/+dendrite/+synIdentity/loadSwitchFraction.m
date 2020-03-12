function [axonSwitchFraction] = loadSwitchFraction()
%LOADSWITCHFRACTION Returns the switch fraction matfile
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

m = matfile(fullfile(util.dir.getMatfile,...
    'axonSwitchFraction.mat'));
axonSwitchFraction = m.axonSwitchFraction;
end

