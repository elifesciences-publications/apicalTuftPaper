function [dataWithHorizontalNoise] = addHorizontalNoise(data,horizontalLocation,noiseLevel)
% addHorizontalNoise This functions add a new column to the array which has a uniform
% noise level around a horizontal location
% INPUT:
%       data: Nx1 array of data
%       horizontalLocation: horizontal location
%       noiseLevel: the noise range
% OUTPUT:
%       dataWithHorizontalNoise: Nx2 array with data plus horizontal noisy
%       location
%Author: Ali Karimi <ali.karimi@brain.mpg.de>
if nargin<3
    noiseLevel=0.4;
end

noiselessLocation=repmat(horizontalLocation,length(data),1);
noisyLocation=noiselessLocation+(rand(size(noiselessLocation))-0.5)*noiseLevel;
dataWithHorizontalNoise=cat(2,noisyLocation,data);
end

