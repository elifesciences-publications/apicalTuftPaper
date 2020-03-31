function [LM] = addLinearFit(array,plotLine,fname,tickFormat)
%ADDLINEARFIT Adds a linear fit to the combined data in array
% INPUT:
%       array: Cell array of data vectors from different sources. The data is
%       combined into an array
%       plotline: flag for adding the line
%       fname: name of text file to save the model summary and gof measures
%       tickformat: line format for the line plotted

% Author: Ali Karimi<ali.karimi@brain.mpg.de>

if ~exist('plotLine','var') || isempty(plotLine)
    plotLine = true;
end

if ~exist('tickFormat','var') || isempty(tickFormat)
    tickFormat = '-';
end
if ~exist('fname','var') || isempty(fname)
    write2file = false;
else
    write2file = true;
end
allX = [];allY = [];
% Get data in vector form
for d = 1:length(array)
    allX = [allX;array{d}(:,1)];
    allY = [allY;array{d}(:,2)];
end

% Linear model fitting
LM = fitlm(allX,allY);
p = LM.Coefficients.Estimate;
if write2file
    % Report important sanity info for text
    fid = fopen(fname,'w+');
    fprintf(fid,'------Output from addLinearFit------\n');
    fprintf(fid,['Linear model: ',num2str(p(2)),'*x',num2str(p(1)),'\n']);
    fprintf(fid,['P-value: ',num2str(coefTest (LM)),'\n']);
    fprintf(fid,['Model Fit Rsquared: ',...
        num2str(LM.Rsquared.Ordinary),'\n']);
    fprintf(fid,['Model Fit Rsquared adjusted to DOF: ',...
        num2str(LM.Rsquared.Adjusted),'\n']);
    % Get the result of disp into a string
    testSummary = evalc('disp(LM)');
    fprintf(fid,'------test Summary------\n');
    fprintf(fid,[testSummary,'\n']);
    fclose(fid);
end
if plotLine
    lineX = linspace(min(allX),max(allX));
    plot(lineX,LM.feval(lineX),tickFormat,'Color','k');
end
end

