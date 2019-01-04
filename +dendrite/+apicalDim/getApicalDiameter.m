function [ apicalDiameter,idx2keep ] = getApicalDiameter(skel,treeIndices )
%GETAPICALDIAMETER Summary of this function goes here
%   Detailed explanation goes here
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
apicalDiameter=cell(max(treeIndices),1);
idx2keep=cell(max(treeIndices),1);
for tr=treeIndices(:)'
    thisApicalDiameter=cellfun(@str2num,{skel.nodesAsStruct{tr}.comment}',...
        'UniformOutput',false);
    idx2keep{tr}= find(cellfun(@(x)~isempty(x),thisApicalDiameter));
    apicalDiameter{tr}=cell2mat(thisApicalDiameter(idx2keep{tr}));
end
end

