function [] = compareTableArrays(tableArray1,tableArray2)
%COMPARETABLES Summary of this function goes here
%   Detailed explanation goes here
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

assert(all(size(tableArray1) == size(tableArray2)));
tableArray1=tableArray1.Variables;
tableArray2=tableArray2.Variables;
cellfun(@apicalTuft.compareTwoTables,tableArray1(:),tableArray2(:));
disp ('Arrays are equal in their tracing tree order')
end

