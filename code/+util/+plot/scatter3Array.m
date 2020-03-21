function [] = scatter3Array(array,color)
% SCATTER3ARRAY Plot scatter plot of 3D points using the scatter3 matlab
% function
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if nargin<2
    color=[0,1,1];
end
assert(ismatrix(array))
if size(array,1)~=3
    array=array';
end
scatter3(array(1,:),array(2,:),array(3,:),200,color,'filled');
end

