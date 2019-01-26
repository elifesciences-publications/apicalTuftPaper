function [] = assessCurrent()
%ASSESSCURRENTDIRECTORY Makes sure we are within the code repository
% directory

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

curDirectoryParts=strsplit(pwd,filesep);
assert(strcmp(curDirectoryParts{end},'apicaltuftpaper'),...
    'MATLAB working directorys should be set to the L1paper repository');
end

