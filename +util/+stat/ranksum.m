function [testResult] = ranksum(array1,array2)
%RANKSUM This function the results of the Wilcoxon ranksum test plus the
% mean and standard error of the mean (sem) for each group
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

[testResult.p,testResult.h,~]=ranksum(array1,array2);
testResult.mean(1)=mean(array1);
testResult.mean(2)=mean(array2);
testResult.sem(1)=util.stat.sem(array1);
testResult.sem(2)=util.stat.sem(array2);
testResult.string=sprintf('Wilcoxon ranksum - H=%f - P=%d - Means: %f, %f - Sem: %f, %f\n',...
    testResult.h,testResult.p,testResult.mean, testResult.sem);
disp(testResult);
end

