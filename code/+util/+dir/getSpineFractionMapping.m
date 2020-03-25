function [spineFractionDir] = getSpineFractionMapping()
%GETSPINEFRACTIONMAPPING Get the directory of spine fraction mapping axons

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
spineFractionDir = fullfile(util.dir.getAnnotation,'spineRatioMapping');

end

