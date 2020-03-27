function [emptyTable] = createEmptyTable(obj,treeIndices,...
    VariableNames,dataType)
% CREATEEMPTYTABLE create an empty table used for outputs in various
% methods. The initial variable of the table is an identifier (tree name in
% nml). The rest of the table is empty used for your variables of interest
% INPUT:
%       obj: The apical tuft object
%       treeIndices: 
%           the indices of trees
%       VariableNames: 
%           The strings used for variable names (initial is always treeIndex)
%       dataType: 'cell' or 'double'
% OUTPUT:
%       emptyTable: The resulting table with the table Index and empty
%       variables

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('VariableNames', 'var') || isempty(VariableNames)
    VariableNames = [{'treeIdx'},obj.synLabel];
end
if ~exist('dataType', 'var') || isempty(dataType)
    dataType = 'cell';
end
treeIdx = obj.getTreeIdentifier(treeIndices);
switch dataType
    case 'cell'
        array = cell(length(treeIdx),length(VariableNames)-1);
        emptyTable = cell2table([treeIdx,array],'VariableNames',...
    VariableNames);
    case 'double'
        array = zeros(length(treeIdx),length(VariableNames)-1);
        arrayT = array2table(array,'VariableNames',VariableNames(2:end));
        emptyTable = table(treeIdx,'VariableNames',...
    VariableNames(1));
        emptyTable = [emptyTable,arrayT];
    otherwise
        error('dataType not valid')
end

end

