% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Set the color variables used frequently for creating the figures
util.setColors()

% Get the local directory to this repository
mainDirectory=fileparts(mfilename('fullpath'));

% Create a text file and write the main Directory into it to use for
% reference later
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

% Large svgs are not correctly saved with the -opengl renderer
set(0, 'DefaultFigureRenderer', 'painters');