function [annotationDir] = getAnnotation()
% getAnnotation Get the directory for annotation data. The .nml files
% generated from the webKnossos skeletonization 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

annotationDir=fullfile(util.dir.getMain,'annotationData');
end

