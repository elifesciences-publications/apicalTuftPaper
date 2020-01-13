function [AnglesPerPath, Endpoints] = FindAllAngles( skeleton, tree,bifurcationNode)
%FINDALLANGLES Summary of this function goes here
%   Detailed explanation goes here

%  Find all endpoints
Endpoints = FindEndpoints(skeleton, tree);

%  Find the branch points
BranchPoints = FindBranchPoints(skeleton,tree);
if isempty(BranchPoints)
    %fprintf('Warning: No Branchpoints in current tree found... \nSkips computation of angles...\n')
    AnglesPerPath = [];
    return
end
%  Go one in each direction from the branch point to find neighbours 
Neighbours = FindNeighbours(skeleton, tree, BranchPoints);


AnglesPerPath = cell(1,length(Endpoints));
for i = 1:length(Endpoints)
    o = Endpoints(i);
    NodesTaken = o;
    BranchPointsTaken = ones(numel(BranchPoints),2);
    BranchPointCounter = 0;
    Angles = [];
    [~, p, NodesTaken] = GoForward(o,o,skeleton, tree, NodesTaken);
    [ ~, ~,~, ~, ~, ~, ~, ~, Angles] = FindPath( o, p, skeleton,tree,...
        Endpoints, BranchPoints, Neighbours, BranchPointCounter,...
        BranchPointsTaken , NodesTaken, Angles,bifurcationNode);
    AnglesPerPath{i} = Angles;
end
end

