function [] = scatter3(location,scale,l2color,dlcolor)
% SCATTER3 plot the 3D location of the bifurcation for visual inspection
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
hold on
util.plot.scatter3Array(location{1}.*scale,l2color)
util.plot.scatter3Array(location{2}.*scale,dlcolor)
hold off
% Correct the aspect ratio and the view of the figure so pia is on top and
% WM is on the bottom
daspect([1,1,1]);
view(0,-90);
end

