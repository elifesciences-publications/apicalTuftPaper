function [ bbox ] = getBoxFromCenSize( center,sizeBox,scale )
% Get bounding box centered around a central point of a certain size
% INPUT:
%       center: 1x3 numeric
%           The center of the bounding box
%       sizeBox: numeric
%           The size of bounding box in micrometer
%       scale: 1x3 numeric, default = [11.24 11.24 30]
%           resolution of dataset in nm3
% OUTPUT:
%       bbox: structure
%           bounding box in matlab and webknossos format
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('scale','var') || isempty(scale)
    scale = [11.24 11.24 30];
end
halfLength = round(repmat(sizeBox*1000,[1,3])./(scale.*2));
bbox.matlab = [(center-halfLength)',(center+halfLength)'];
bbox.WK = [(center-halfLength),halfLength.*2];
fprintf('\nbounding box for wK: %u,%u,%u,%u,%u,%u\n',bbox.WK);
end

