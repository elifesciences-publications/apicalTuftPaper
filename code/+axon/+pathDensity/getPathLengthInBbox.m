function [pathLengthInside] = getPathLengthInBbox(skel,bboxes)
% getPathLengthInBbox Gives the pathlength of 1. layer 2 and 2. deep layer
% trees within the bounding box
if ismatrix(bboxes)
    pathLengthInside=zeros([size(bboxes),1,2]);
else
    pathLengthInside=zeros([size(bboxes),2]);
end
for X=1:size(bboxes,1)
    for Y=1:size(bboxes,2)
        for Z=1:size(bboxes,3)
            bbox=bboxes{X,Y,Z};
            skelRestricted2bbox=skel.restrictToBBox(bbox);
            pathLengthInside(X,Y,Z,1)=...
                sum(skelRestricted2bbox.pathLength...
                (skelRestricted2bbox.l2Idx,skel.scale/1000));
            pathLengthInside(X,Y,Z,2)=...
                sum(skelRestricted2bbox.pathLength...
                (skelRestricted2bbox.dlIdx,skel.scale/1000));
        end
    end
end
end

