function [testResult] = ranksum(array1,array2,fname)
%RANKSUM This function the results of the Wilcoxon ranksum test plus the
% mean and standard error of the mean (sem) for each group
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('fname','var') || isempty(fname)
    writeResult=false;
else
    writeResult=true;
end
[testResult.p,testResult.h,~]=ranksum(array1,array2);
testResult.mean(1)=mean(array1);
testResult.mean(2)=mean(array2);
testResult.ratio1over2=mean(array1)./mean(array2);
testResult.ratio2over1=mean(array2)./mean(array1);
testResult.percent1over2=(mean(array1)./mean(array2))*100;
testResult.percent2over1=(mean(array2)./mean(array1))*100;
testResult.sem(1)=util.stat.sem(array1);
testResult.sem(2)=util.stat.sem(array2);
testResult.string=sprintf(...
    'Wilcoxon ranksum - H=%f - P=%d \nMeans: %f, %f \nSEM: %f, %f\n',...
    testResult.h,testResult.p,testResult.mean, testResult.sem);
testResult.N1= length(array1);
testResult.N2 = length(array2);
disp(testResult.string);
% Write as a table
if writeResult
writetable(struct2table(testResult),[fname,'.xlsx']);
end
end

