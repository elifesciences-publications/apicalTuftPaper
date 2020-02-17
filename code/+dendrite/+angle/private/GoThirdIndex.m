function [ o_new, p_new, NodesTaken_new ] = GoThirdIndex( o, p, skeleton, tree, NodesTaken )
%GOSECONDINDEX For a node which is a branching point go into the direction of the second index in the edges array
%   o is the node id you came from
%   p is the node id you currently are
%   skeleton is a skeleton type structure
%   tree is the tree id you are currently analysing 

[row, col] = find(skeleton.edges{tree}==p);
othercol = FindOppositeCol(col);
counter = 0;

    for k = 1:length(row)
        if o ~= skeleton.edges{tree}(row(k),othercol(k))
            if counter == 0
               counter = 1;
            elseif counter == 1
                counter = 2;
            elseif counter == 2
               o_new = p; 
               p_new = skeleton.edges{tree}(row(k),othercol(k));
               NodesTaken_new = [NodesTaken, p_new];
            end
        end
    end

end