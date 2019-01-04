function [skel] = relSomaDistance(skel,treeIndices,toString,additionalDist)
% relSomaDistance This function updates the connectedComp.synDistance2Soma
% property of the object with the distance between the soma location
% node (toString) and the synapse ID on the backbone from the 
% connectedComp.synIdx
% Note: the code is only valid for two synapse types (Shaft and Spine)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('toString','var') || isempty(toString)
    toString='start';
end
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
if ~exist('additionalDist','var') || isempty(additionalDist)
    additionalDist=zeros(size(treeIndices));
end
% Get the location of the other point to compare to soma
somaLocationIdx=skel.getNodesWithComment(skel.(toString),...
    treeIndices,'partial');
% Make sure it is a cell
if ~iscell(somaLocationIdx)
    somaLocationIdx={somaLocationIdx};
end
% check point uniqueness per tree
assert(all(cellfun(@length,somaLocationIdx)==1),...
        'location comment is not unique');

% Get all path for the treeIndices
allPaths=skel.getShortestPaths(treeIndices);
skel.distSoma.synDistance2Soma=...
    skel.createEmptyTable(treeIndices,{'treeIdx','Shaft','Spine'},'cell');

% Get all the distances to
for i=1:length(treeIndices)
    % Get values for the current tree
    tr=treeIndices(i);
    curSomalocationIdx=somaLocationIdx{i};
    curAllPaths=allPaths{1,i};
    for synType=2:3
        skel.distSoma.synDistance2Soma{tr,synType}{1}=...
            (curAllPaths(curSomalocationIdx,...
            skel.connectedComp.synIdx{tr,synType}{1})'./1000)+...
            additionalDist(i);
    end
end

end

