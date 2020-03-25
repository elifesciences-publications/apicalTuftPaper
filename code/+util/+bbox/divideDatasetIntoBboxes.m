function [bbox] =divideDatasetIntoBboxes(datasetBbox,bboxSize,fixTheOrigin)
% divide dataset into bounding boxes
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('fixTheOrigin','var') || isempty(fixTheOrigin)
    fixTheOrigin = false;
end
XBounds = util.bbox.getBlocks(datasetBbox(1,:),bboxSize(1),fixTheOrigin);
YBounds = util.bbox.getBlocks(datasetBbox(2,:),bboxSize(2),fixTheOrigin);
ZBounds = util.bbox.getBlocks(datasetBbox(3,:),bboxSize(3),fixTheOrigin);
bbox = cell(length(XBounds),length(YBounds),length(ZBounds));
for X = 1:length(XBounds)
    for Y = 1:length(YBounds)
        for Z = 1:length(ZBounds)
            bbox{X,Y,Z} = [XBounds{X};YBounds{Y};ZBounds{Z}];
        end
    end
end

end

