function [obj] = ...
    deleteNonUniqueNodeCoord(obj,treeIndices)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees();
end
% Test beforehand as well: see end of function
assert(length(obj.splitCC.names) == length(obj.names))
for i = 1:length(treeIndices)
    tr = treeIndices(i);
    % Unique values
    coords = obj.getNodes(tr);
    [~,idxu,idxc] = unique(coords,'rows');
    [count, ~, idxcount] = histcounts(idxc,numel(idxu));
    idxkeep = count(idxcount)>1;
    % Create Table: node idx, coords, comments and grouping of these
    % duplicates
    doubleNodeIndices = find(idxkeep)';
    if isempty(doubleNodeIndices)
        continue
    else
        comments = {obj.nodesAsStruct{tr}(doubleNodeIndices).comment}';
        nonUniqueCoords = coords(idxkeep,:);
        [~,~,groupingOfDoubles] = unique(nonUniqueCoords,'rows');
        allInfo = table(doubleNodeIndices,groupingOfDoubles,nonUniqueCoords,comments);
        allInfo = sortrows(allInfo,'groupingOfDoubles');
        
        % Check that you don't have more than 1 node with comments per
        % duplication location
        emptycomments = cellfun(@isempty,allInfo.comments);
        commentedNodes = allInfo.groupingOfDoubles(~emptycomments);
        assert(length(unique(commentedNodes)) == ...
            length(commentedNodes));
        % keep commented nodes
        allInfo = allInfo(emptycomments,:);
        % Init to delete nodeIdx,
        % First add all the counterparts of the commented nodes
        nodes2delete = [];
        counterParts = ismember(allInfo.groupingOfDoubles,commentedNodes);
        nodes2delete = [nodes2delete,allInfo.doubleNodeIndices(counterParts)'];
        allInfo = allInfo(~counterParts,:);
        
        % We would like to just keep 1 of each of the remaining node
        % duplicates. i.e. make them unique
        [~,uniqueIndices,~] = unique(allInfo.groupingOfDoubles);
        indices2del = setdiff(1:height(allInfo),uniqueIndices);
        nodes2delete = [nodes2delete,allInfo.doubleNodeIndices(indices2del)'];
        obj = obj.deleteNodes(tr,nodes2delete,true);
    end
end
% Make sure no additional CC is created from node deletion
assert(length(obj.splitCC.names) == length(obj.names));
% Check the unqiueness of all nodes
assert(isempty(obj.getNonUniqueNodeCoord))
end

