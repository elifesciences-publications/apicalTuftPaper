function [synapseSizeComparisonDir] = getSynapseSize()
%getSynsizeComparison Get the directory of synapse size annotations 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

synapseSizeComparisonDir=fullfile(util.dir.getAnnotation,'synapseSize');

end

