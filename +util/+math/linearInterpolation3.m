function [pInterp] = linearInterpolation3(pnts,Location,dim)
%LINEARINTERPOLATION 
v=pnts(2,:)-pnts(1,:);
locationAlongPath=(Location-pnts(1,dim))/(pnts(2,dim)-pnts(1,dim));
pInterp=round(pnts(1,:)+locationAlongPath*v);
end

