function [ o_new, p_new, NodesTaken_new ] = GoForward( o, p, skeleton, tree, NodesTaken )
%GOFORWARD For a node which is neither a branching point nor an endpoint go
%to the next node q, which differs from the one you came before
%   o is the node id you came from
%   p is the node id you currently are
%   skeleton is a skeleton type structure
%   tree is the tree id you are currently analysing 

[row, col] = find(skeleton.edges{tree}==p);
othercol = FindOppositeCol(col);
    for k = 1:length(row)
        if o ~= skeleton.edges{tree}(row(k),othercol(k))
           o_new = p; 
           p_new = skeleton.edges{tree}(row(k),othercol(k));
           NodesTaken_new = [NodesTaken, p_new];
           return
        end
    end

end

