function [nLM] = addNonLinearFit(array,model,plotLine,fname,beta0,tickFormat)
%ADDNONLINEARFIT Summary of this function goes here
%   Detailed explanation goes here

if ~exist('plotLine','var') || isempty(plotLine)
    plotLine = true;
end
% Default: exponential model
if ~exist('model','var') || isempty(model)
    model = fittype('exp1');
end
if ~exist('beta0','var') || isempty(beta0)
    beta0 = [];
end
if ~exist('fname','var') || isempty(fname)
    write2file=false;
else
    write2file=true;
end
if ~exist('tickFormat','var') || isempty(tickFormat)
    tickFormat = '-';
end
allX=[];allY=[];
% Get data in vector form
for d=1:length(array)
    allX=[allX;array{d}(:,1)];
    allY=[allY;array{d}(:,2)];
end

% Linear model fitting
nLM=fitnlm(allX,allY,model,beta0);
p = nLM.Coefficients.Estimate;
if write2file
    fid = fopen(fname,'a');
    fprintf(fid,'------Output from addLinearFit------\n');
    fprintf(fid,['Model formula',func2str(model),'\n']);
    fprintf(fid,['non- Linear model params (b): ',num2str(p'),'\n']);
    fprintf(fid,['P-value: ',coefTest(nLM),'\n']);
    fprintf(fid,['Model Fit Rsquared: ',num2str(nLM.Rsquared.Ordinary),'\n']);
    fprintf(fid,['Model Fit Rsquared adjusted to DOF: ',num2str(nLM.Rsquared.Adjusted),'\n']);
    testSummary = evalc('disp(nLM)');
    fprintf(fid,'------test Summary------\n');
    fprintf(fid,[testSummary,'\n']);
    fclose(fid);
end
if plotLine
    lineX=linspace(min(allX),max(allX));
    plot(lineX,nLM.feval(lineX),tickFormat,'Color','k');
end
end

