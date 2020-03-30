function [RotMatrix] = getRotationMatrixPPC2(theSurfSwitch)
% GETROTATIONMATRIXPPC2 uses L1/2 border surface to get the rotation matrix
% that makes the dataset vertical

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
switch theSurfSwitch
    case 'l1'
        m = load(fullfile(util.dir.getMatfile,'l1.mat'));
        theSurf = m.l1;
    case 'pia'
        m = load(fullfile(util.dir.getMatfile,'pia.mat'));
        theSurf = m.pia;
    otherwise
        error('You need to choose either "pia" or "l1" surface')
end
% Get the rotation matrix which makes the L1 border parallel to the X-Y
% plane and the Z-axis equivalent to Pia-WM axis 
% normal vector = [0,0,1], tangential plane
[x,y] = meshgrid(1:10,1:10);z = theSurf.fitSurfaceNM(x,y);
% Since it is a plane all the surface norms match
[Nx,Ny,Nz] = surfnorm(x,y,z);
normalV = [Nx(1),Ny(1),Nz(1)];
% get the rotation matrix between the normal vector of L1 surface and the
% tangential plane normal vector
tangNormal = [0 0 1];
r = vrrotvec(normalV,tangNormal);
RotMatrix = vrrotvec2mat(r);
% Make sure that the rotation matrix generates the normal to the the XY
% plane from application of the rotation matrix to the normal of the
% surface
assert(isequal(uint8(RotMatrix*normalV'),tangNormal'));
end

