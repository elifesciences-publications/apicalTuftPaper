function [bbox] = divideDatasetIntoSlices(fullDatasetBBox,...
    sectionThickness,axisSectioned)
% divideDatasetIntoSlices Given a bounding box and slice thickness, Create
% cell array containing bounding boxes for each individual slice. Used to
% slice the path length of neurites into slices for quantization.
% INPUT:
%       fullDatasetBBox: 3x2 numeric array
%                       The full dataset bounding box along the three
%                       dimensions [Xmin,Xmax;Ymin,Ymax;Zmin,Zmax]
%       sectionThickness: numeric
%                       Section thickness in nanometers
%       axisSectioned: numeric (1-3)
%                       dimension used for the sectioning for
%                       histogram/density maps along the depth of cortex
% OUTPUT:
%       bbox: cell array of 3x2 numeric arrays
%       bounding box of each depth slice
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Get the bound of the slicing along the dimension of interest
Bounds = util.bbox.getBlocks...
    (fullDatasetBBox(axisSectioned,:),sectionThickness);

% Initialize the bbox array with the full dataset bbox
bbox = cell(length(Bounds),1);
bbox = repmat({fullDatasetBBox},size(bbox));

% dimension corrected along the sectioning dimension (Usually Y-axis)
for b = 1:length(Bounds)
    bbox{b,1}(axisSectioned,:) = Bounds{b};
end

% Round the bbox values
bbox = cellfun(@round,bbox,'UniformOutput',false);
end

