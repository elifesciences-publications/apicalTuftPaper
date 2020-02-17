function [ branchNodes ] = getBranchNodesToDel( skel,tr,realTreeEndings)
% getBranchNodesToDel returns all the degree 2 nodes between
% the degree 1 nodes and a node that has a higher degree plus the
% degree seed. It is meant to be used in the getBackbone method
% INPUT:
%       tr: numeric value
%           The tree Index
%       realTreeEndings: Nx1 double array
%           The degree one nodes which
% OUTPUT:
%       branchNodes: 1xN numeric array
%           All the nodes in the tree which are currently a
%           degree 1 node or are between a degree 1 node and a higher than
%           2 degree node which we would like to delete in getBackbone
% Note: Repeated usage of this function results on a backbone
% Authors: Ali Karimi <ali.karimi@brain.mpg.de>
%          Jan Odenthal <jan.odenthal@brain.mpg.de>
Neighbors=skel.getNeighborList(tr);
degree1Nodes=find(cellfun(@(x)length(x)==1,Neighbors));
% Avoid trimming the real endings of the tracing signified by specific
% comments
degree1Nodes=setdiff(degree1Nodes,realTreeEndings);
steps=0;

%If there's no degree 1 nodes left return an empty array
if isempty(degree1Nodes)
    branchNodes=[];
    return
end

% This loop would walk along the tree starting at each branch ending and
% would stop when a node does not have a degree 2
for ii=1:length(degree1Nodes)
    contSignal=true;
    currentNode=degree1Nodes(ii);
    nextNode=Neighbors{currentNode};
    while contSignal
        steps=steps+1;
        branchNodes(steps)=currentNode;
        if  length(Neighbors{nextNode})==2
            oldNode=currentNode;
            currentNode=nextNode;
            nextNode=Neighbors{nextNode}(Neighbors{nextNode}~=oldNode);
        else
            contSignal=false;
        end
    end
end

end
