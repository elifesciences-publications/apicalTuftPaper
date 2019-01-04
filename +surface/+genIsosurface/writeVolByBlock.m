function [] = writeVolByBlock(wkwPath,bbox,vol)
% writeVolByBlock Writes the volume annotation in blocks of 32x32x32 voxels
% This function ignores empty blocks
try
    wkwInit('new', wkwPath, 32, 1, 'uint32', 1)
catch
    disp ('Already Initialized')
end

% Chop bounding boxes into blocks of 32^3
fixTheOrigin=true;
bboxSize=[32,32,32];
bboxChopped=util.bbox.divideDatasetIntoBboxes(bbox,bboxSize,fixTheOrigin);

% Chop the volume into corresponding volumes
[~,XLengths] = util.bbox.getBlocks(bbox(1,:),bboxSize(1),fixTheOrigin);
[~,YLengths] = util.bbox.getBlocks(bbox(2,:),bboxSize(2),fixTheOrigin);
[~,ZLengths] = util.bbox.getBlocks(bbox(3,:),bboxSize(3),fixTheOrigin);
volChopped=mat2cell(vol,XLengths,YLengths,ZLengths);

% Get the indices of non-empty blocks
[X,Y,Z]=ind2sub(size(volChopped),...
    find(cellfun(@(x)any(x(:)),volChopped)));
Idx=[X,Y,Z];

% Loop over non-empty blocks and write them down
for i=1:size(Idx,1)
    x=Idx(i,1);y=Idx(i,2);z=Idx(i,3);
    wkwSaveRoi(wkwPath, bboxChopped{x,y,z}(:,1)',...
        uint32(volChopped{x,y,z}));
end
end

