function [emptyTemplate] = createTableTemplate(tableTemplate,variableTypes)
%CREATETABLETEMPLATE Table template from a specific Table
tSize = size(tableTemplate);
if  ~exist('variableTypes','var') || isempty(variableTypes)
    variableTypes = repmat({'cell'},[1,tSize(2)]);
end

emptyTemplate = table('Size',tSize,'VariableTypes',...
    variableTypes,'VariableNames',...
    tableTemplate.Properties.VariableNames,'RowNames', ...
    tableTemplate.Properties.RowNames);
end

