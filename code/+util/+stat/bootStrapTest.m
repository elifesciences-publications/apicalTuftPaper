function [ pValues ] = bootStrapTest( groupul,groupdl,...
    testTypeOneSided,weight)
% BOOTSTRAPTEST Takes bootstrap samples from the concatenation of the
% groupul and group dl. Calculates the fraction of times the bootstrap
% sample has a more extreme value (in two-sided case) as the p-value
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
bootN = 100000;
ulLength = size(groupul,1);
dlLength = size(groupdl,1);
if ~exist('testTypeOneSided','var') || isempty(testTypeOneSided)
    testTypeOneSided = false;
end
% Give flat weight to all samples if weight not given
if ~exist('weight','var') || isempty(weight)
    weight = ones(ulLength+dlLength,1);
end
% function to calculate the mean of difference in each bootstrap trial
meanFunc = @(x) mean(x(1:ulLength,:))-mean(x(ulLength+1:ulLength+dlLength,:));
%concatenate the two groups for the bootstrapping
allSpec = [groupul;groupdl];
%boot strap results
if istable(allSpec)
    allSpecVariableNames = allSpec.Properties.VariableNames(2:end);
    allSpec = allSpec{:,2:end};
else
    allSpecVariableNames = {'UpperApical', 'DeeperApical',...
        'soma', 'AIS', 'spine', 'shaft'};
end

[bootstat,~] = bootstrp(bootN,meanFunc,allSpec,'Weights',weight);
%make table to make it more understable
resultTable = array2table(bootstat,'VariableNames',allSpecVariableNames);

sampleResult = array2table(meanFunc(allSpec),'VariableNames',allSpecVariableNames);

%add SampleValues to the result table
resultTable = [resultTable;sampleResult];
%This function measure the ratio of boot trials that have a value more
%extreme than the real sample value
if testTypeOneSided
    pValueFunction = @(x) min(sum(x(1:end-1) <= x(end)),sum(x(1:end-1) >= x(end)))/bootN;
else
    pValueFunction = @(x) (min(sum(x(1:end-1) <= x(end)),sum(x(1:end-1) >= x(end)))...
        +min(sum(x(1:end-1) <= -x(end)),sum(x(1:end-1) >= -x(end))))/bootN;
end
% apply to all the variables in the table
pValues = varfun(pValueFunction,resultTable);
end

