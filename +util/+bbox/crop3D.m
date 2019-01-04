function [vol] = crop3D(vol,bbox)
%CROP3D 
X=bbox(1,1):bbox(1,2);Y=bbox(2,1):bbox(2,2);Z=bbox(3,1):bbox(3,2);
vol=vol(X,Y,Z);
end

