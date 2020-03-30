function [dist] = dist2plane(thisfit,allPoints,signed)
%% Function to calculate the distance from a point to a plane

% input:
%   allPoints:  3xN matrix of point coordinates
%   thisfit:   sfit to be converted
% output:
%   dist:  distance from each point to the surface
% from: https://mathinsight.org/distance_point_plane
% Normal distance between a point (xp,yp,zp) and a plane (Ax+By+Cz+D = 0)
% dist = |Axp+Byp+Czp+D|/sqrt(A^2+B^2+C^2)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Note: It would make sense to use the fitSurfaceNM and convert the
% coordinates to NM as well. Then the distance would be in NM as well
if ~exist('signed','var') || isempty(signed)
    signed = false;
end
A = thisfit.p10;
B = thisfit.p01;
C = -1;
D = thisfit.p00;
distformula.unsigned = @(point) abs(A*point(1)+B*point(2)+C*point(3)+D)/sqrt(A^2+B^2+C^2);
distformula.signed = @(point) (A*point(1)+B*point(2)+C*point(3)+D)/sqrt(A^2+B^2+C^2);
if size(allPoints,1) == 1
    pCell = {allPoints};
else
    assert(size(allPoints,1) == 3)
    pCell = num2cell(allPoints,1);
end
% Absolute or signed value
if signed
    dist = cellfun(distformula.signed,pCell);
else
    dist = cellfun(distformula.unsigned,pCell);
end

end