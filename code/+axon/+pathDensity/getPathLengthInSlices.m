function [pathLengthInside] = getPathLengthInSlices(skel,bboxes)
% GETPATHLENGTHINSLICES Get the  pathlength of axons given a skeleton and a
% set of bounding boxes representing each slice
% INPUT:
%       skel: apicalTuft object
%       bboxes: N x 1 cell array
%           bounding boxes for each slice
% OUTPUT:
%       pathLengthInside: N x 2 numeric
%                       path length of axons within each cortical depth
%                       slice for L2 and DL seeded axons

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

assert(ismatrix(bboxes))
pathLengthInside = zeros([length(bboxes),2]);
for b = 1:length(bboxes)
    bbox = bboxes{b};
    % Restrict the annotations to the current bounding box
    skelRestricted2bbox = skel. ...
        restrictToBBoxWithInterpolation(bbox);
    % Get the path length (within bbox) for L2 and DL ADs
    l2Length = ...
        sum(skelRestricted2bbox.pathLength...
        (skelRestricted2bbox.l2Idx).pathLengthInMicron);
    dlLength = ...
        sum(skelRestricted2bbox.pathLength...
        (skelRestricted2bbox.dlIdx).pathLengthInMicron);
    pathLengthInside(b,:) = [l2Length,dlLength];
end
end

