function [ o, p, Endpoints, BranchPoints, Neighbours, ...
           BranchPointCounter, BranchPointsTaken , NodesTaken, ...
           Angles] = FindPath( o, p, skeleton, tree, Endpoints, ...
           BranchPoints, Neighbours, BranchPointCounter, ...
           BranchPointsTaken, NodesTaken, Angles,bifurcationNode)
%FINDPATH This is the FindPath function without calculating the pathlength
%and usable only if axon branches in max. 2 nodes
%   Detailed explanation goes here
while 1
    while (~any(Endpoints == p) && ~any(BranchPoints == p))
        [o, p, NodesTaken] = GoForward(o, p, skeleton, tree, NodesTaken);
    end
    if any(BranchPoints == p)
       BranchPointCounter = BranchPointCounter + 1;
       BranchPointsTaken(BranchPointCounter, 1) = p;
       BranchPointsTaken(BranchPointCounter, 2) = 0;
       Angles = CalculateAngle( o, p, skeleton, tree, BranchPoints, ...
                                Neighbours, Endpoints, Angles,bifurcationNode );
                            
       [o, p, NodesTaken] = GoForward(o, p, skeleton, tree, NodesTaken);
    end

    if any(Endpoints == p)

        for checkBranchPoints = size(BranchPointsTaken,1):-1:1
            if~BranchPointsTaken(checkBranchPoints,2)
               ThisBranchPointsNeighbours = Neighbours{ismember(BranchPoints, ...
               BranchPointsTaken(checkBranchPoints,1))}(2:4,1);
               for i = 1:length(NodesTaken)
                   if ~isempty(intersect(NodesTaken(i),ThisBranchPointsNeighbours))
                      First = NodesTaken(i);
                      break
                   end
               end
               o = First;
               p = BranchPointsTaken(checkBranchPoints,1);
               [o, p, NodesTaken] = GoSecondIndex(o,p,skeleton,tree, NodesTaken);
               BranchPointsTaken(checkBranchPoints,2) = 1;
               [ o, p, Endpoints, BranchPoints, Neighbours, BranchPointCounter, ...
                   BranchPointsTaken , NodesTaken, Angles ] = FindPath( o, p, ...
                   skeleton, tree, Endpoints, BranchPoints, Neighbours, ...
                   BranchPointCounter, BranchPointsTaken , NodesTaken, Angles,bifurcationNode);
            end
        end
        
        if BranchPointsTaken(1,2)
           return
        end
    end
end

end