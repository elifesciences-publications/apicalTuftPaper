function [fourPoints] = drawSquareAroundPoint(coord)
% DRAWSQUAREAROUNDPOINT draws a square with edge length of 20 um around a
% central coordinate (main bifurcation)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

halfSizeSquare = 10000;
coord = coord(:);
fourPoints(:,1) = coord + [0,-halfSizeSquare,-halfSizeSquare]';
fourPoints(:,2) = coord + [0,-halfSizeSquare,halfSizeSquare]';
fourPoints(:,3) = coord + [0,halfSizeSquare,halfSizeSquare]';
fourPoints(:,4) = coord + [0,halfSizeSquare,-halfSizeSquare]';
fourPoints(:,5) = fourPoints(:,1);
fourPoints(1,:) = 0;
plot3(fourPoints(1,:),fourPoints(2,:),fourPoints(3,:),'Color','k')
end

