function [] = assessCurrent()
%ASSESSCURRENTDIRECTORY Makes sure we are within the code repository
% directory

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

curDirectoryParts=strsplit(pwd,filesep);
assert(strcmp(curDirectoryParts{end},'apicaltuftpaper'),...
    'MATLAB working directories should be set to the apicaltuftpaper repository');
end

