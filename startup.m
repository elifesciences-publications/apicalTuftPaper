% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Make sure you are in the apical tuft paper directory for the startup
util.dir.assessCurrent;
% Set the color variables used frequently for creating the figures
util.setColors()
% Get the local directory to this repository
mainDirectory = util.dir.getMain;

% Add the full repository to matlab search path
addpath(genpath(mainDirectory))
clear mainDirectoryParts mainDirectory fid;

% Painter renderer is necessary for saving large SVG files apporpriately
set(0, 'DefaultFigureRenderer', 'painters');