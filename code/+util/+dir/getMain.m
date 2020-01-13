function [mainDirectory] = getMain()
% getMain This function reads the main directory file from

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
mainDirectory = fileparts(mfilename('fullpath'));
assert(contains(mainDirectory,'apicaltuftpaper'),...
    'To get the top directory of the repository it should be named apicaltuftpaper');
splitOverMain = strsplit(mainDirectory,'apicaltuftpaper');
mainDirectory = fullfile(splitOverMain{1},'apicaltuftpaper');
end

