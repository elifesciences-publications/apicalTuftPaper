function [bboxes] = slicePiaWMaxis(tuftArray,sliceThickness)
%SLICEPIAWMAXIS 
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
% Default
if ~exist('sliceThickness','var') || isempty(sliceThickness)
    sliceThickness = 20000;
end
assert(...
    all(cellfun(@(x) x.datasetProperties.dimPiaWM == 2,tuftArray)));
dimPiaWM = 2;
% max+100 along the pia WM direction
bboxesOfDatasets = cellfun(@(x) x.getBbox([],false), tuftArray,...
    'UniformOutput',false);
unionBboxes = util.bbox.bboxUnion(bboxesOfDatasets,true);
% Initialize
bboxes = util.bbox.divideDatasetIntoSlices...
        (unionBboxes,sliceThickness,dimPiaWM);

end

