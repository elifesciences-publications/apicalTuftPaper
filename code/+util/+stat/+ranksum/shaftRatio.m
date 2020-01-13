function shaftRatio(shaftRatio,names,file)
% shaftRatio Applies the ranksum function to the shaft ratios in Figure 1
% INPUT:
%       shaftRatio
%       names: cell array
%           Dataset names
%       file: character
%           Name of file to write the results

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fileID=fopen(file,'w+');
for dataset=1:5
    testResults=util.stat.ranksum(shaftRatio{1,dataset},shaftRatio{2,dataset});
    fprintf(fileID,...
        [names{dataset},' Wilcoxon ranksum test result for Shaft Ratio: h=%d, p=%d\n'],...
        testResults.h,testResults.p);
end
end

