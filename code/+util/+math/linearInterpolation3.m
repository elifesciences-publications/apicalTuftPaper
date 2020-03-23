function [pInterp] = linearInterpolation3(pnts,pointOfInterestInDim,dim)
% LINEARINTERPOLATION linealy interpolate a 3D edge along one dimension
% INPUT:
%       pnts: The two points constituting an edge
%       pointOfInterestInDim: coordinate of the point of interest along dim
%       dim: dimension of interest for the interpolation
% OUTPUT:
%       pInterp: The interpolated node at the point of interest. This is
%       equivalent to the crosssection of the edge and the plane created by
%       the coordinate of pointOfInterestInDim.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

v = pnts(2,:)-pnts(1,:);
locationAlongPath = (pointOfInterestInDim-pnts(1,dim))/...
    (pnts(2,dim)-pnts(1,dim));
pInterp = round(pnts(1,:) + locationAlongPath*v);
assert(pInterp(dim) == pointOfInterestInDim);
end

