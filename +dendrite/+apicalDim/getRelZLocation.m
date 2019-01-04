function [ location ] = getRelZLocation( skel,treeIndices,idx2keep,dimension,directionUp)
%GETRELZLOCATION calculates the z location of a node for which I calculated
%the diameter of apical
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
location=cell(max(treeIndices),1);
locationBottom=500;
dimensionString='xyz';
for tr=treeIndices(:)'
    thisZlocation=cellfun(@str2num,{skel.nodesAsStruct{tr}.(dimensionString(dimension))}',...
        'UniformOutput',false);
    if directionUp
        location{tr}=-(cell2mat(thisZlocation(idx2keep{tr}))-...
            locationBottom).*skel.scale(dimension)./1000;
    else
        location{tr}=(cell2mat(thisZlocation(idx2keep{tr}))-...
            locationBottom).*skel.scale(dimension)./1000;

    end
    
    
end

