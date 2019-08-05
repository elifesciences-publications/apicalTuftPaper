function [outTbl] = combineDistalL5A(inTbl)
%COMBINEDISTALL5A combine the results from the two distal L5A annotations
L5Atag='layer5AApicalDendrite_mapping';
inTbl=sortrows(inTbl);
outTbl=table('Size',[width(inTbl),3],'VariableTypes',...
    repmat({'double'},width(inTbl),1),'VariableNames',...
    inTbl.Properties.VariableNames);
% Change the treeName variable type to cell
outTbl.treeIndex=num2cell(outTbl.treeIndex);
for tr=1:3
    curTreeName=sprintf([L5Atag,'%0.2u'],tr);
    indices=contains(inTbl.treeIndex,curTreeName);
    outTbl{tr,'treeIndex'}{1}=curTreeName;
    outTbl{tr,2:end}=sum(inTbl{indices,2:end},1);
end
end

