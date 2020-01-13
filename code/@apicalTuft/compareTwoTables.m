function compareTwoTables(table1,table2)
%COMPARETWOTABLES Make sure the two tables have the same order of trees
assert(isequal(table1{:,1},table2{:,1}),...
    'treeIndices of the two tables compared are not equal')
disp ('the index (first) column is equal between the two tables');
end

