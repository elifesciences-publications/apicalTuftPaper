function []=mkdir(dirPath, verbose)
% Creates the directory if it does not exist already
% Author <ali.karimi@brain.mpg.de>
if ~exist('verbose','var') || isempty(verbose)
    verbose = false;
end
% Make folder
if ~isfolder(dirPath)
    mkdir(dirPath);
    if verbose
        disp(['Created directory: ',dirPath])
    end
else
    if verbose
        disp(['directory already present: ',dirPath])
    end
end
end
