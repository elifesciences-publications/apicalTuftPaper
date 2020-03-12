function [dir] = getExcelDir(excelSheetFigID)
% getExcelDir Get directories for saving excel files of raw data
% INPUT:
%       excelSheetFigID: Numeric: the id of figure related to the data
% OUTPUT:
%       figDir: String: directory for saving the figure
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

dir = fullfile(util.dir.getMain,'data','Other','excelSheet',...
    ['Fig',num2str(excelSheetFigID)]);
util.mkdir(dir,false);
end

