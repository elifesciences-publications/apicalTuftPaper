function [f] = addLinearFit(array,model,plotLine,fname)
%ADDLINEARFIT Summary of this function goes here
%   Detailed explanation goes here

if ~exist('plotLine','var') || isempty(plotLine)
    plotLine = true;
end
% Default: linear model going through the origin
if ~exist('model','var') || isempty(model)
    model = fittype('poly1');
end
if ~exist('fname','var') || isempty(fname)
    write2file=false;
else
    write2file=true;
end
curX=[];curY=[];
% Get data in vector form
for d=1:length(array)
    curX=[curX;array{d}(:,1)];
    curY=[curY;array{d}(:,2)];
end

% Linear model fitting
[f,gof]=fit(curX,curY,model);
% Add the information about correlation coefficient
util.stat.correlationStatFileWriter(curX, curY,fname,f);
if write2file
    fid = fopen(fname,'a');
    fprintf(fid,'------Output from addLinearFit------\n');
    fprintf(fid,['Linear model: ',num2str(f.p1),'*x+',num2str(f.p2),'\n']);
    fprintf(fid,['Model Fit Rsquared: ',num2str(gof.rsquare),'\n']);
    fclose(fid);
end
if plotLine
    ax=gca;
    lineX=linspace(ax.XLim(1),ax.XLim(2));
    plot(lineX,f(lineX),'Color','k');
end
end

