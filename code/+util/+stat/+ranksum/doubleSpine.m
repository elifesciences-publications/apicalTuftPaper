function [] = doubleSpine(doubleSpineFraction,file)
%doubleSpine ranksum test for inhibitory spine ratios
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fileID=fopen(file,'w+');
results=util.stat.ranksum(doubleSpineFraction{1},doubleSpineFraction{2});
fprintf(fileID,'Wilcoxon ranksum for double spines- h=%f, p=%f\n',...
    results.h,results.p);

fclose(fileID);
end

