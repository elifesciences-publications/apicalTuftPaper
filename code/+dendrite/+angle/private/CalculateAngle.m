function [ Angles ] = CalculateAngle( o, p, skeleton, tree, BranchPoints, Neighbours, Endpoints, Angles,bifurcationNode)
%CALCULATEANGLE calculates the branching angle at a given branch point

%   for a given branch point p and prior point o this function
%   computes the branching angle and appends it to the array Angles
if bifurcationNode == p
    keepAngle = true;
else
    keepAngle = false;
end
[ xscale, yscale, zscale ] = getscales( skeleton );
radius = 2;       % set the radius of the sphere here
nod = [];
BranchPoint = p;
ThisBranchPointNeighbours = Neighbours{ismember(BranchPoints, p)};
[~, IndexWithouto] = setdiff(ThisBranchPointNeighbours(:,1),[o, p]);

a_i = ThisBranchPointNeighbours(IndexWithouto(1),2:4);
b_i = ThisBranchPointNeighbours(IndexWithouto(2),2:4);

%   Go in direction of first neighbour
if (~any(Endpoints == ThisBranchPointNeighbours(IndexWithouto(1),1)) && ~any(BranchPoints == ThisBranchPointNeighbours(IndexWithouto(1),1)))
    [o, p, ~] = GoForward(BranchPoint, ThisBranchPointNeighbours(IndexWithouto(1),1), skeleton, tree, nod);
    a_i = [a_i; skeleton.nodes{tree}(p,1:3)];
end
while (norm(bsxfun(@times, ThisBranchPointNeighbours(1,2:4), [xscale, yscale, zscale]) - bsxfun(@times,skeleton.nodes{tree}(p,1:3), [xscale, yscale, zscale])) <= radius && ...
        (~any(Endpoints == p)) && (~any(BranchPoints == p)))
    [o, p, ~] = GoForward(o, p, skeleton, tree, nod);
    a_i = [a_i; skeleton.nodes{tree}(p,1:3)];
end


%   Go in direction of second neighbour
if (~any(Endpoints == ThisBranchPointNeighbours(IndexWithouto(2),1)) && ~any(BranchPoints == ThisBranchPointNeighbours(IndexWithouto(2),1)))
    [o, p, ~] = GoForward(BranchPoint, ThisBranchPointNeighbours(IndexWithouto(2),1), skeleton, tree, nod);
    b_i = [b_i; skeleton.nodes{tree}(p,1:3)];
end
while (norm(bsxfun(@times, ThisBranchPointNeighbours(1,2:4), [xscale, yscale, zscale]) - bsxfun(@times,skeleton.nodes{tree}(p,1:3), [xscale, yscale, zscale])) <= radius && ...
        (~any(Endpoints == p)) && (~any(BranchPoints == p)))
    [o, p, ~] = GoForward(o, p, skeleton, tree, nod );
    b_i = [b_i; skeleton.nodes{tree}(p,1:3)];
end

%  Compute mean vectors and angle

a_i = bsxfun(@minus, a_i, ThisBranchPointNeighbours(1,2:4));
b_i = bsxfun(@minus, b_i, ThisBranchPointNeighbours(1,2:4));
a_i = mean(a_i,1);
a_i(1) = a_i(1) * xscale; a_i(2) = a_i(2) * yscale;a_i(3) = a_i(3) * zscale;

b_i = mean(b_i,1);
b_i(1) = b_i(1) * xscale; b_i(2) = b_i(2) * yscale;b_i(3) = b_i(3) * zscale;


angle = atan2(norm(cross(a_i,b_i)),dot(a_i,b_i));
if keepAngle
    Angles = [Angles rad2deg(angle)];
end

end