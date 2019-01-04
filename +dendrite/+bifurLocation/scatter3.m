function [outputArg1,outputArg2] = scatter3(location,scale,l2color,dlcolor)
%SCATTER3 Summary of this function goes here
%   Detailed explanation goes here
hold on
util.plot.scatter3Array(location{1}.*scale,l2color)
util.plot.scatter3Array(location{2}.*scale,dlcolor)
hold off
end

