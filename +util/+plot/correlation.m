function [Rho,pval] = correlation(array,colors,markers,crossSize)
% PLOTCORRELATION plots the correlation between two values. 
% INPUT: 
%       array: cell array with each cell having N x 2 structures. 
%           first column is the X and second column is the Y values
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('markers','var') || isempty(markers)
    markers = repmat({'x'},size(array));
end
if ~exist('crossSize','var') || isempty(crossSize)
    crossSize=36;
end
% Remove empty cell array entries
nonEmpty=~cellfun(@isempty,array);
array=array(nonEmpty);
colors=colors(nonEmpty);
markers=markers(nonEmpty);


totalX=[];totalY=[];
hold on
for d=1:length(array)
    curX=array{d}(:,1);
    curY=array{d}(:,2);
    scatter(curX,curY,crossSize,colors{d},markers{d});
    totalX=[totalX;curX];
    totalY=[totalY;curY];
end
% Get the correlation coefficient and its significance level
[Rho,pval]=corr(totalX,totalY);
fprintf(['Correlation Coefficient is: ',num2str(Rho),'\n',...
    'The p-value is: ',num2str(pval),'\n']);
fprintf(['Maximum X is: ',num2str(max(totalX)),'\n',...
    'The Maximum Y is: ',num2str(max(totalY)),'\n'])
end

