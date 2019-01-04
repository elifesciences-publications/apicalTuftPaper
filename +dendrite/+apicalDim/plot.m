function [ output_args ] = plot( parameter,apicalDiameter,treeIndices)
%PLOT Summary of this function goes here
%   Detailed explanation goes here
colors=distinguishable_colors(max(treeIndices));
hold on
for tr=treeIndices(:)'
matrix2plot=sortrows([parameter{tr},apicalDiameter{tr}]);
plot(matrix2plot(:,1),matrix2plot(:,2),'Color',colors(tr,:));
end
hold off
end

