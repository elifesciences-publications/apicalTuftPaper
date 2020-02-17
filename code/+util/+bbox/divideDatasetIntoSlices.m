function [bbox] = divideDatasetIntoSlices(datasetBbox,...
    sliceThickness,dimension)
%DIVIDEDATASETINTOSLICES Slice dataset into bboxes of same size
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

Bounds=util.bbox.getBlocks(datasetBbox(dimension,:),sliceThickness);
bbox=cell(length(Bounds),1);
for b=1:length(Bounds)
    bbox{b,1}=datasetBbox;
    bbox{b,1}(dimension,:)=Bounds{b};
end
bbox=cellfun(@round,bbox,'UniformOutput',false);
end

