function objTrimmed = getBackBone(obj,treeIndices,...
    comments2Avoid,trimLastEdgeTPA,makeDebugPlots)
% getBackBone This function deletes all the branch nodes until there's no
% degree 1 node left except for the real endings specified by
% comments2Avoid
%   INPUT:
%           treeIndices: [1xN] or [Nx1] vector, default: all trees
%               Array of the tree Indices to do the trimming
%           comments2Avoid: 1xN  cell: default: obj.fixedEnding
%               comments specifying the real tree endings such as 'end', 'exit',etc.
%               add your spine comment to keep the spine neck such
%               as 'sp' or 'Spine'
%           trimLastEdgeTPA: logical, default: false
%               Flag to trim the last edge of three point annotation. Set based
%               on tracing type.
%           makeDebugPlots: logical, default: false
%               Flag to decide whether to
% 	OUTPUT:
%           objTrimmed:
%               The apiclTuft object with trees trimmed
%   Authors: Ali Karimi <ali.karimi@brain.mpg.de>
%            Jan Odenthal <jan.odenthal@brain.mpg.de>

% Defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end

if ~exist('comments2Avoid','var') || isempty(comments2Avoid)
    comments2Avoid = obj.fixedEnding;
end
if ~exist('trimLastEdgeTPA','var') || isempty(trimLastEdgeTPA)
    trimLastEdgeTPA =false;
end
if ~exist('makeDebugPlots','var') || isempty(makeDebugPlots)
    makeDebugPlots = false;
end
if ~iscell(obj.synExclusion)
    obj.synExclusion = {obj.synExclusion};
end

% Initialize the object with trimmed tree
objTrimmed = obj;
for tr = treeIndices(:)'
    realTreeEndings = [];
    for c = 1:size(comments2Avoid,2)
        realTreeEndings = cat(1,realTreeEndings,objTrimmed.getNodesWithComment...
            (comments2Avoid{c},tr,'exact'));
    end
    realTreeEndings = removeunsure(objTrimmed,realTreeEndings,tr);
    % Get the first round of nodes which need to be deleted
    nodes2Del = objTrimmed.getBranchNodesToDel(tr,realTreeEndings);
    
    % This while loop would continue until there's no
    while ~isempty(nodes2Del)
        % Make sure the real endings of the tree are not deleted
        assert(isempty(intersect(nodes2Del,realTreeEndings)),...
            'The real tree endings should not be deleted');
        % Delete the nodes from last round
        objTrimmed = objTrimmed.deleteNodes(tr,nodes2Del,true);
        % Update the real tree ending Indices
        realTreeEndings = [];
        for cc = 1:size(comments2Avoid,2)
            realTreeEndings = cat(1,realTreeEndings,...
                objTrimmed.getNodesWithComment(comments2Avoid{cc},...
                tr,'exact'));
        end
        % Remove unsure from real tree endings
        realTreeEndings = removeunsure(objTrimmed,realTreeEndings,tr);
        nodes2Del = objTrimmed.getBranchNodesToDel(tr,realTreeEndings);
    end
    % if spines are avoided delete the last extra node of the spine 3 point
    % annotation
    if trimLastEdgeTPA
        if any(cellfun(@(x)contains(x,'spine'),comments2Avoid))
            spineLastNode = objTrimmed.getNodesWithComment('spine',tr,'partial');
            objTrimmed = objTrimmed.deleteNodes(tr,spineLastNode,true);
        end
    end
    
end

if makeDebugPlots
    % Create overlay of before and after trimming for sanity check
    % Do this for each individual tree and pause for key press
    for i = 1:length(treeIndices)
        tr = treeIndices(i);
        fh = figure('Name',obj.names{tr},...
            'units','normalized','outerposition',[0 0 1 1]);
        obj.plot(tr,[0,1,1]);
        objTrimmed.plot(tr,[1,0,1]);
        view([90,0]);
        daspect([1,1,1]);
        title([obj.dataset,...
            ' Cyan: Original(untrimmed), Magenta: Backbone (trimmed)']);
        uiwait(fh);
    end
end
end

function realTreeEndings = removeunsure(objTrimmed,realTreeEndings,tr)
%Avoiding to keep unsure synapse in the case of a spine keeping
unsureSynapse = [];
for cm = 1:length(objTrimmed.synExclusion)
    unsureSynapse = [unsureSynapse,objTrimmed. ...
        getNodesWithComment(objTrimmed.synExclusion{cm}, tr, 'partial')];
end
unsureSynapse = unique(unsureSynapse);
realTreeEndings = setdiff(realTreeEndings,unsureSynapse);
end





