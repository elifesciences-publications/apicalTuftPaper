function [mainDirectory] = getMain()
% getMain This function reads the main directory file from

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.dir.assessCurrent;
fid=fopen(fullfile('directories','mainDirectory.txt'),'r');
resultTextScan=textscan(fid,'%s');
fclose(fid);
mainDirectory=resultTextScan{1}{1};
end

