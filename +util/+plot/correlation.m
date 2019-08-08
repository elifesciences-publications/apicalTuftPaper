function [] = correlation(array,colors)
% PLOTCORRELATION plots the correlation between two values. 
% INPUT: 
%       array: cell array with each cell having N x 2 structures. 
%           first column is the X and second column is the Y values
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
crossSize=36;
hold on
for d=1:length(array)
    curX=array{d}(:,1);
    curY=array{d}(:,2);
    scatter(curX,curY,crossSize,colors{d},'.');
end

end

