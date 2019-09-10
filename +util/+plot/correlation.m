function [Rho,pval] = correlation(array,colors,markers,crossSize,fname)
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
if ~exist('fname','var') || isempty(fname)
    write2file=false;
else
    write2file=true;
end
% Remove empty cell array entries
nonEmpty=~cellfun(@isempty,array);
array=array(nonEmpty);
colors=colors(nonEmpty);
markers=markers(nonEmpty);
% Merge all the cell array elements for the correlation plot
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
if write2file
    [Rho,pval] = corr(totalX,totalY);
    fid = fopen(fname,'w+');
    modelUnity=@(x) x;
    Rsquared = util.stat.coeffDetermination(modelUnity, [totalX,totalY]);
    fprintf(fid, ['Correlation Coefficient is: ',num2str(Rho),'\n',...
        'The p-value is: ',num2str(pval),'\n']);
    fprintf(fid, ['Maximum X is: ',num2str(max(totalX)),'\n',...
        'The Maximum Y is: ',num2str(max(totalY)),'\n']);
    fprintf(fid, ['R squared is: ',num2str(Rsquared),'\n']);
    fclose(fid);
end
end

