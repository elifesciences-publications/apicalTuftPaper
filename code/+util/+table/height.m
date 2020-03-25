function [h] = height(table)
%HEIGHT returns the height of table. Ignoring the empty entries in a table
%array
if isempty(table)
    h = 0;
else
    h = height(table);
end
end

