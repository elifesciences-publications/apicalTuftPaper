function [ distnacesShaft,distancesSpine ] = distanceFromBifurcation( skel,treeIdx,sanityCheck)
%MOVESYNTOSHAFT Summary of this function goes here
%   Detailed explanation goes here
%
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Setting default values
if ~exist('treeIdx','var') || isempty(treeIdx)
    treeIdx = 1:skel.numTrees;
end
if ~exist('sanityCheck','var') || isempty(sanityCheck)
    sanityCheck = false;
end

skelBackBone = skel.getBackBone(treeIdx);

% Plot the results for visual inspection
if sanityCheck
    figure('Name',skel.filename)
    skel.plot(treeIdx,[1 0 0]);
    hold on
    skelBackBone.plot(treeIdx,[0 0 1]);
    daspect([1 1 1])
    drawnow
end

% Get coordinates of synapses. format currently {shaft,spine}
[~,synCoords,~] = skel.getSynIdsNrs(treeIdx);
synCoords = struct2table(synCoords);
trId = @(tr)['treeId' num2str(tr)]; 
%define anonymous function to get the closest node to each synapse
spineFunction = @(tr) cellfun(@ (xyz,tree) skelBackBone.getClosestNode(xyz,tree)...
    ,num2cell(synCoords.(trId(tr)){2},2),repmat({tr},[size(synCoords.(trId(tr)){2},1),1]));
shaftFunction = @(tr) cellfun(@ (xyz,tree) skelBackBone.getClosestNode(xyz,tree)...
    ,num2cell(synCoords.(trId(tr)){1},2),repmat({tr},[size(synCoords.(trId(tr)){1},1),1]));

%Get spine/ shaft nodes and the bifurcation
spineNodes = arrayfun(spineFunction,treeIdx,'UniformOutput',false);
shaftNodes = arrayfun(shaftFunction,treeIdx,'UniformOutput',false);
bifurcation = skelBackBone.getNodesWithComment('bifurcation'...
    ,treeIdx,'exact',true);
assert(all(cellfun(@length,bifurcation) == 1),...
    'bifurcation is not unique');
distArrayTrees = arrayfun(@(x)skelBackBone.getShortestPaths(x)/1000,...
    treeIdx,'UniformOutput',false);

%functions to calculate the distance between the bifurcation and shaft or
%spine synapses
getShortestPathShaft = @(tr) arrayfun(@ (idx1,idx2) distArrayTrees{tr}(idx1,idx2)...
    ,shaftNodes{tr},repmat(bifurcation{tr},size(shaftNodes{tr})));
getShortestPathSpine = @(tr) arrayfun(@ (idx1,idx2) distArrayTrees{tr}(idx1,idx2)...
    ,spineNodes{tr},repmat(bifurcation{tr},size(spineNodes{tr})));

%Measuring the distance
distnacesShaft = arrayfun(getShortestPathShaft,1:length(treeIdx),'UniformOutput',false);
distancesSpine = arrayfun(getShortestPathSpine,1:length(treeIdx),'UniformOutput',false);
end

