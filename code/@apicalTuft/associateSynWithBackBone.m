function [skel] = associateSynWithBackBone...
    (skel,treeIndices,debugPlot)
% ASSOCIATESYNWITHBACKBONE Associate each synapse node with its node on the
% shaft backbone annotations

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees();
end
if ~exist('debugPlot', 'var') || isempty(debugPlot)
    debugPlot = false;
end

% Get information for all trees
skelTrimmed = skel.getBackBone;
shortestPaths = skel.getShortestPaths;
synIdx = skel.getSynIdx;

for i = 1:length(treeIndices)
    tr = treeIndices(i);
    % Get the Idx of backbone in the untrimmed annotation
    IdxMapFromBackBone2Full = ...
        skel.nodeIdxToIdxAnotherSkel(skelTrimmed,tr);
    IdxMapFromBackBone2Full = IdxMapFromBackBone2Full{1};
    % Get the shortest path between synapse Idx and the backbone Idx. This
    % would be the Idx of the synapse on the backbone
    curShortestPaths = shortestPaths{tr};
    cursynIdx = synIdx(tr,:);
    
    % Initialize
    synIdxBackBone = cell(1,width(cursynIdx));
    synIdxBackBone{1} = cursynIdx{1,1};
    for synGroup=2:width(cursynIdx)
        curSynTypeIdx=cursynIdx{1,synGroup}{1};
        currentShortestDist = curShortestPaths(IdxMapFromBackBone2Full,...
            curSynTypeIdx);
        [minValues,minIndices] = min(currentShortestDist,[],1);
        % Checks:
        % 8 um spine neck threshhold
        assert(length(minValues) == length(curSynTypeIdx))
        assert(all(minValues<8000)); 
        backBoneNodesWithMinDist=IdxMapFromBackBone2Full(minIndices);
        if length(minIndices)>1
            synIdxBackBone{1,synGroup} = ...
                backBoneNodesWithMinDist;
        else
            synIdxBackBone{1,synGroup} = ...
                {backBoneNodesWithMinDist};
        end
        assert(...
            max(backBoneNodesWithMinDist) <= length(skel.nodes{tr}),...
            'Make sure synapse backbone Idx are within Range');
        assert(length(backBoneNodesWithMinDist)==length(curSynTypeIdx),...
            'Make sure synapse numbers are not changed')
    end
    skel.connectedComp.synIdx(i,:) = cell2table(synIdxBackBone,...
        'VariableNames',...
        cursynIdx.Properties.VariableNames);
    if debugPlot
        plotDebug
    end
end
% Get the ID table
skel.connectedComp.synIDPre = getIDTable(skel,skel.connectedComp.synIdx,...
treeIndices);

    % Function to plot the debug figure
    function plotDebug
        clf
        skel.plot(tr);
        % scatter plot backone coords for checking
        backBoneCoords = skel.getNodes(tr,IdxMapFromBackBone2Full,1);
        util.plot.scatter3(backBoneCoords,[1,0,0]);
        % Plot the backbone synapse lines for debugging
        edgesSpine = [skel.connectedComp.synIdx.Spine{tr},...
            cursynIdx.Spine{1}];
        edgesShaft = [skel.connectedComp.synIdx.Shaft{tr},...
            cursynIdx.Shaft{1}];
        trNodes = bsxfun(@times,skel.nodes{tr}(:,1:3),skel.scale);
        hold on
        for ed = 1: size(edgesSpine,1)
            curEd = edgesSpine(ed,:);
            plot3(trNodes(curEd,1),...
                trNodes(curEd,2), trNodes(curEd,3),'m')
        end
        for ed = 1:size(edgesShaft,1)
            curEd = edgesShaft(ed,:);
            plot3(trNodes(curEd,1),...
                trNodes(curEd,2), trNodes(curEd,3),'g')
        end
        spineCoords = trNodes(synIdx.Spine{i},:);
        shaftCoords = trNodes(synIdx.Shaft{i},:);
        util.plot.scatter3(spineCoords,'m',100);
        util.plot.scatter3(shaftCoords,'g',100);
    end

end
function synNumberPerNodeID = getIDTable(skel,synIdxBackbone,treeIndices)
% Create a sparse matrix of synapse number and node ID 
synNumberPerNodeID = synIdxBackbone;
Idx2IDMap = repmat(skel.nodeIdx2Id(treeIndices),1,...
width(synNumberPerNodeID)-1);
% Get each node ID and the number of synapses that have that specific ID
synIDCount = @(syn,idx2IdMap) ...
    [idx2IdMap(unique(syn)),histc(syn,unique(syn))];
curSynNumbers= ...
    cellfun(synIDCount,synIdxBackbone{:,2:end},...
    Idx2IDMap,'UniformOutput',false);
synNumberPerNodeID{:,2:end} = curSynNumbers;
% Make sure synapse count does not change
assert(isequal(cellfun(@(x) sum(x(:,2)),curSynNumbers), ...
    skel.getSynCount{:,2:end}));
end

