function [table2] = copyRVNames(table1,table2)
%COPYRVNAMES copy row and variable names of table 1 in table 2
table2.Properties.VariableNames = table1.Properties.VariableNames;
table2.Properties.RowNames = table1.Properties.RowNames;
end

