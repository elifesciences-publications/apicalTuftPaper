function [limit2Choose,interpolatedNodeValid] = ...
    crossBboxAndEdges(nodesOfAnEdge,bbox,dim)
% CROSSBBOXANDEDGES Find the bbox edge that the edge given crosses.
% INPUT:
%       nodesOfAnEdge: 2x3 numeric
%                   The coordinate of the two nodes
%       bbox: 3x2 numeric
%           The bounding box limits
%       dim:
%           dimension along which the edge is supposed to cross (usually
%           Y). This dimension usually is along pia-WM axis
% OUTPUT:
%       limit2Choose: numeric
%           The edge of the bounding box. This is usually used for the
%           interpolation in apicalTuft.restrictToBBoxWithInterpolation
%       interpolatedNodeValid: logical
%           This flag reports whether one of the nodes is exactly on the
%           edge so that the interpolation is not done
% coordinate of the two nodes

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

interpolatedNodeValid = true;
nodesAlongDim = nodesOfAnEdge(:,dim);
bboxAlongDim = bbox(dim,:);
% Find the correct edge of the bbox along the correct dimension
if max(nodesAlongDim) > max(bboxAlongDim) && ...
        min(nodesAlongDim) > min(bboxAlongDim)
    limit2Choose = bbox(dim,2);
elseif max(nodesAlongDim) < max(bboxAlongDim) && ...
        min(nodesAlongDim) < min(bboxAlongDim)
    limit2Choose = bbox(dim,1);
else
    error('problem with the crossing')
end
if ismember(limit2Choose, nodesAlongDim)
    disp(['interpolation gives the same result as ',...
        'one of the data points'])
    interpolatedNodeValid = false;
end
end

