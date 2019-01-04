function [limit2Choose,interpolatedNodeValid] = ...
    crossBboxAndEdges(nodesOfAnEdge,bbox,dim)
% CROSSBBOXANDEDGES
interpolatedNodeValid=true;
if max(nodesOfAnEdge(:,dim))>max(bbox(dim,:)) && ...
        min(nodesOfAnEdge(:,dim))>min(bbox(dim,:))
    limit2Choose=bbox(dim,2);
elseif max(nodesOfAnEdge(:,dim))<max(bbox(dim,:)) && ...
        min(nodesOfAnEdge(:,dim))<min(bbox(dim,:))
    limit2Choose=bbox(dim,1);
else
    error('problem with the crossing')
end
if ismember(limit2Choose,nodesOfAnEdge(:,dim))
    % warning(['interpolation gives the same result as ',...
    %    'one of the data points'])
    interpolatedNodeValid=false;
end
end

