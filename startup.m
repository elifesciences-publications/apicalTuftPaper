% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Make sure you are in the apical tuft paper directory for the startup
util.dir.assessCurrent;
% Set the color variables used frequently for creating the figures
util.setColors()
% Get the local directory to this repository
mainDirectory = util.dir.getMain;

% Add the full repository to matlab search path
addpath(genpath(mainDirectory))

% Get the file server directory (GUI prompt) and save to a mat file if the
% matfile does not exist
if ~exist(fullfile(util.dir.getMatfile,'remoteDir.mat'),'file')
    util.dir.updateRemote;
end

clear mainDirectory fid;
% Painter renderer is necessary for saving large SVG files apporpriately
set(0, 'DefaultFigureRenderer', 'painters');