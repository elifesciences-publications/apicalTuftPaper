function [skel_unbranched] = unBranchSkel(skel)
% Function that takes a Skeleton and converts it into an unbranched
% Skeleton, for which each branched tree is split up into segments of
% unbranched (path) graphs - (works with recursion => watch for proper recursion depth)
% author: Martin Schmidt <martin.schmidt@brain.mpg.de>

% Sort for taskID's - to go through trees in sorted mode: treeindex k -> idx_list_sorted(k)
[~, idx_list_sorted] = sort(skel.names);


% Copy skeleton with all properties
skel_unbranched = skel;

% Then delete all trees in copied skeleton and set new filename
skel_unbranched = skel_unbranched.deleteTrees(1:length(skel.nodes));
skel_unbranched.largestID = 0; % If this is not set, after all trees are deleted,
                               % it subsequently produces an error in the addTree() method
skel_unbranched.filename = [skel_unbranched.filename '_unbranched'];

ann_num = 1; % annotator number

for k = 1:length(skel.nodes) % loop over trees in original skeleton
    tree_idx = idx_list_sorted(k); % Go through skeleton in sorted mode (sorted after taskID)
    disp(['Processing Tree ' num2str(k) ' of ' num2str(length(skel.nodes)) ' - ' num2str(100*k/length(skel.nodes)) '% done'])

    visited_points_logical = zeros(length(skel.nodes{tree_idx}),1); % Ensures that all points are reached
    
    eps = skel.getEndpoints(tree_idx);
    neighbors = skel.getNeighborList(tree_idx);
    
    % get old tree name - append annotator number
    orig_tree_name = skel.names(tree_idx);
    orig_tree_name = [orig_tree_name{1} '_ann_' num2str(ann_num)];
    
    subgraph = 1;
    
    % while not all eps were reached - do unbranching
    % Usually this should only run once, as webKnossos only allows one
    % connected component in each tree
    while ~isempty(eps)
        curr_tree_subgraph_name = orig_tree_name;
        
        if subgraph > 1
            disp(['Subgraph: ' num2str(subgraph)]);
            curr_tree_subgraph_name = [orig_tree_name '_subgraph_' num2str(subgraph)];
        end

        start_node = eps(1);
        next_node = neighbors{start_node};
        
        visited_points_logical(start_node) = 1;
        
        % Add first new Tree with start_node:
        [skel_unbranched, curr_tree] = skel_unbranched.addTree(curr_tree_subgraph_name, skel.nodes{tree_idx}(start_node,:));
        
        % Start unbranching current tree
        [skel_unbranched, visited_points_logical] = unBranchTree(skel, skel_unbranched, tree_idx, curr_tree, start_node, 1, next_node, neighbors, curr_tree_subgraph_name, visited_points_logical);
        subgraph = subgraph + 1;
        
        visited_ep_logical = visited_points_logical(eps);
        eps = eps(~visited_ep_logical);
    end
    
    % in case there is a next iteration:
    if k < length(skel.nodes)
        next_tree_idx = idx_list_sorted(k+1);
        % and in case the taskID is the same in the next iteration:
        if strcmp(skel.names{tree_idx},skel.names{next_tree_idx})
            % increase the annotator number
            ann_num = ann_num + 1;
        % in case the taskID is not the same in next iteration:
        else
            % reset annotator number
            ann_num = 1;
        end
    end
    
end
end




function [ unbr_skel, visited_points_logical ] = unBranchTree( orig_skel, unbr_skel, orig_tree, curr_tree, orig_last_node, act_last_node, orig_curr_node, neighbors, orig_tree_name, visited_points_logical)
% Helper function that recursivly explores a tree of orig_skel and splits
% it up at branch points into new trees of unbr_skel
% author: martin.schmidt@brain.mpg.de

curr_neighbors = neighbors{orig_curr_node};
number_of_neighbors = size(curr_neighbors,2);
next_neighbors = curr_neighbors;
next_neighbors(curr_neighbors == orig_last_node) = []; % Delete last_node from next_neighbors
number_of_next_neighbors = number_of_neighbors-1;

% Add curr_node to curr_tree
unbr_skel = unbr_skel.addNode(curr_tree, orig_skel.nodes{orig_tree}(orig_curr_node, 1:3), act_last_node, orig_skel.nodes{orig_tree}(orig_curr_node, 4), orig_skel.nodesAsStruct{orig_tree}(orig_curr_node).comment);
visited_points_logical(orig_curr_node) = 1;
act_last_node = act_last_node + 1;

% Differentiate between branchpoint, endpoint and 2-neighbors-point
if number_of_next_neighbors == 1
    [unbr_skel, visited_points_logical] = unBranchTree(orig_skel, unbr_skel, orig_tree, curr_tree, orig_curr_node, act_last_node, next_neighbors, neighbors, orig_tree_name, visited_points_logical);
elseif number_of_next_neighbors == 0
    % Endpoint reached
    return
else
    % Loop over not-yet-visited-neighbors of a branchpoint
    for k = 1:number_of_next_neighbors
        next_node = next_neighbors(k);
        new_tree_name = [orig_tree_name '_branchpoint_' int2str(orig_curr_node) '_branch_' int2str(k)];
        [unbr_skel, new_tree ] = unbr_skel.addTree(new_tree_name, orig_skel.nodes{orig_tree}(orig_curr_node,:));
        [unbr_skel, visited_points_logical] = unBranchTree(orig_skel, unbr_skel, orig_tree, new_tree, orig_curr_node, 1, next_node, neighbors, orig_tree_name, visited_points_logical);
    end
end
end

