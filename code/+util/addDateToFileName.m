function [ nameDateAdded] = addDateToFileName(name)
%addDateToName Adds date to the name of the file as a suffix
% INPUT:
%       name: character vector
%           of format name or name.filetype
% OUTPUT:
%       nameDateAdded: character vector
%           of format name_date or name_date.filetype
% Note: there should only be one dot in the name

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

dateStr=datestr(datetime('now'));
dateStr(regexp(dateStr,' '))='-';
dateStr(regexp(dateStr,':'))='-';
if contains(name,'.')
    nameParts=strsplit(name,'.');
    assert(length(nameParts) == 2,'More than 1 dot in the name')
    nameDateAdded=strcat(nameParts{1},'_',dateStr,'.',nameParts{2});
else
    nameDateAdded=strcat(name,'_',dateStr);
end


end
