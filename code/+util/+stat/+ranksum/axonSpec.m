function [] = axonSpec(spec,file)
%axonSpec processes ranksum for figure 2c
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fileID=fopen(file,'w+');
testResults=util.stat.ranksum(spec{1},spec{3});
fprintf(fileID,['L2Specificity: ',...
    '%s'],...
    testResults.string);
testResults=util.stat.ranksum(spec{2},spec{4});
fprintf(fileID,['DeepSpecificity: ',...
    '%s'],...
    testResults.string);

end

