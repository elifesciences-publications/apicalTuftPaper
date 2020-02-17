function [pathLengthInside] = getPathLengthInSlices(skel,bboxes)
%GETPATHLENGTHINSLICES Get the  pathlength in bboxes, In micrometer
assert(ismatrix(bboxes))
pathLengthInside=zeros([length(bboxes),2]);
for b=1:length(bboxes)
    bbox=bboxes{b};
    skelRestricted2bbox=skel. ...
        restrictToBBoxWithInterpolation(bbox);
    pathLengthInside(b,1)=...
        sum(skelRestricted2bbox.pathLength...
        (skelRestricted2bbox.l2Idx).pathLengthInMicron);
    pathLengthInside(b,2)=...
        sum(skelRestricted2bbox.pathLength...
        (skelRestricted2bbox.dlIdx).pathLengthInMicron);
    
end
end

