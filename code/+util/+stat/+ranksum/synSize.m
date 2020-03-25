function [] = synSize(synSize,synTag,file)
%synSize Applies ranksum function to synSize data

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fileID = fopen(file,'w+');
for synType = 1:2
    [p,h,~] = ranksum(synSize{1,synType,5},synSize{2,synType,5});
    fprintf(fileID,'Wilcoxon ranksum for %s size- h = %f, p = %f\n',...
        synTag{synType},h,p);
end
fclose(fileID);
end

