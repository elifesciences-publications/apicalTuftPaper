function [] = write(tableArray, fileName)
% WRITE write a 2D table of tables into a series of sheets in the excel file
% INPUT:
%       tableArray: 2D table array with row and column names
%                   The table array of tables
%       fileName: string
%                   The name of the excel sheet

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

for i = 1:width(tableArray)
    for j = 1:height(tableArray)
        sheetName = [tableArray.Properties.VariableNames{i},'_',...
            tableArray.Properties.RowNames{j}];
        writetable(tableArray{j,i}{1}, fileName, 'Sheet', sheetName,...
            'WriteRowNames',true);
    end
end
end

