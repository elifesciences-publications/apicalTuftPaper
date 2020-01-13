function [outTbl] = combineDistalL5A(inTbl,fun)
%COMBINEDISTALL5A combine the results from the two distal L5A annotations

if ~exist('fun','var') || isempty(fun)
    fun = @(x)sum(x,1);
end
% Parameters
L5Atag='layer5AApicalDendrite_mapping';
numL5Acells=3;
% Generate output table
inTbl=sortrows(inTbl,1);
varTypes=varfun(@class,inTbl,'OutputFormat','cell');
outTbl=table('Size',[numL5Acells,width(inTbl)],'VariableTypes',...
    varTypes,'VariableNames',...
    inTbl.Properties.VariableNames);
% Go over each L5A cell and combine the results from the two annotations
for tr=1:numL5Acells
    curTreeName=sprintf([L5Atag,'%0.2u'],tr);
    indices=contains(inTbl.treeIndex,curTreeName);
    outTbl{tr,'treeIndex'}{1}=curTreeName;
    outTbl{tr,2:end}=fun(inTbl{indices,2:end});
end
end

