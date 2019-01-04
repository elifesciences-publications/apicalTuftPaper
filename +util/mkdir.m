function []=mkdir(dirPath)
% Creates the directory if it does not exist already
% Author <ali.karimi@brain.mpg.de>

if ~isdir(dirPath)
    mkdir(dirPath);
    disp(['Created directory: ',dirPath])
else
    disp(['directory already present: ',dirPath])
end
end
