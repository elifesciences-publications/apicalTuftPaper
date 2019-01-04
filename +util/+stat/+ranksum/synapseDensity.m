function synapseDensity(shaftDensity,spineDensity,names,file)
% synapseDensity this function performs the shaft spine density comparison
% INPUT:
%       shaftDensity,spineDensity
%       names: cell array
%           Dataset names
%       file:
%           file to write out the results

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fileID=fopen(file,'w+');
for dataset=1:5
    [p,h,~]=ranksum(shaftDensity{1,dataset},shaftDensity{2,dataset});
    fprintf(fileID,[names{dataset},' Wilcoxon ranksum for ShaftDensity- h=%d, p=%d\n'], h,p);
    [p,h,~]=ranksum(spineDensity{1,dataset},spineDensity{2,dataset});
    fprintf(fileID,[names{dataset},' Wilcoxon ranksum for SpineDensity- h=%d, p=%d\n'], h,p);
end
fclose(fileID);
end

