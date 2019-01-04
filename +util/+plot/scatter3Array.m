function [] = scatter3Array(array,color)
%SCATTER3ARRAY Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    color=[0,1,1];
end
assert(ismatrix(array))
if size(array,1)~=3
    array=array';
end
scatter3(array(1,:),array(2,:),array(3,:),200,color,'filled');
end

