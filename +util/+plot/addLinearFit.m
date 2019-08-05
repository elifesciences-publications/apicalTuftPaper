function [] = addLinearFit(array,model,plotLine)
%ADDLINEARFIT Summary of this function goes here
%   Detailed explanation goes here

if ~exist('plotLine','var') || isempty(plotLine)
    plotLine = true;
end
% Default: linear model going through the origin
if ~exist('model','var') || isempty(model)
    model = fittype({'x'});
end
curX=[];curY=[];
% Get data in vector form
for d=1:length(array)
    curX=[curX;array{d}(:,1)];
    curY=[curY;array{d}(:,2)];
end
% Linear model fitting
[f,gof]=fit(curX,curY,model);
disp(['Linear model: ',num2str(f.a),'*x']);
disp(['Model Fit Rsquared: ',num2str(gof.rsquare)]);
if plotLine
    ax=gca;
    lineX=linspace(ax.XLim(1),ax.XLim(2));
    plot(lineX,f(lineX),'Color','k');
    %daspect([1,1,1]);
end
end

