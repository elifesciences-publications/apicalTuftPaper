function [ apicalDiameter,idx2keep ] = getApicalDiameter...
    (skel,treeIndices )
%GETAPICALDIAMETER 
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
apicalDiameter=cell(length(treeIndices),1);
idx2keep=cell(length(treeIndices),1);
for tr=1:length(treeIndices)
    treeId=treeIndices(tr);
    thisApicalDiameter=cellfun(@str2num,...
        {skel.nodesAsStruct{treeId}.comment}',...
        'UniformOutput',false);
    idx2keep{tr}= find(cellfun(@(x)~isempty(x),thisApicalDiameter));
    apicalDiameter{tr}=cell2mat(thisApicalDiameter(idx2keep{tr}));
end
treeIndex=skel.getTreeIdentifier(treeIndices);
apicalDiameter=table(treeIndex,apicalDiameter);
end

