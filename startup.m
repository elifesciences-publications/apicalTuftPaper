% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set the colors used for layer 2 (grey) and deep layer group (orange)
util.setColors()

% Get the local directory to this repository
mainDirectory=fileparts(mfilename('fullpath'));

% Create a text file and write the main Directory into it to use for
util.mkdir(fullfile(mainDirectory,'directories'));
fid=fopen(fullfile(mainDirectory,'directories','mainDirectory.txt'),'w+');
[~]=fprintf(fid,'%s',mainDirectory);
[~]=fclose(fid);

% Check that the name of main directory ends with the name of repository
mainDirectoryParts=strsplit(mainDirectory,filesep);
assert(strcmp(mainDirectoryParts{end},'apicaltuftpaper'));

% Add the full repository to matlab search path
addpath(genpath(mainDirectory))
clear mainDirectoryParts mainDirectory fid;
