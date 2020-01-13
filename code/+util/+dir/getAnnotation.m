function [annotationDir] = getAnnotation()
% getAnnotation Get the directory for raw annotation data 
% (skeleton reconstructions). 
% The .nml files generated from the webKnossos skeletonization 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

annotationDir = fullfile(util.dir.getMain,'data','skeletonReconstruction');
end

