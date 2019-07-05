function [RotMatrix] = getRotationMatrixPPC2()
% GETROTATIONMATRIXPPC2 uses L1/2 border surface to get the rotation matrix 
% that makes the dataset vertical 
m=load(fullfile(util.dir.getAnnotation,'matfiles','l1.mat'));
l1border=m.l1;
% Get the rotation matrix which makes the L1 border parallell to the xz
% surface (normal vector=[0,0,1], tangential plane)
[x,y]=meshgrid(1:10,1:10);z=l1border.fitSurfaceNM(x,y);
[Nx,Ny,Nz]=surfnorm(x,y,z);
normalV=[Nx(1),Ny(1),Nz(1)];
% get the rotation matrix between the normal vector of L1 surface and the
% tangential plane normal vector
tangNormal=[0 0 1];
r=vrrotvec(normalV,tangNormal);
RotMatrix=vrrotvec2mat(r);
assert(isequal(uint8(RotMatrix*normalV'),tangNormal'));
end

