% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Note: run inside the main directory (ending in apicaltuftpaper)
addpath(genpath('code'))

% Get the file server directory (GUI prompt) and save to a mat file if the
% matfile does not exist
if ~exist(fullfile(util.dir.getMatfile,'remoteDir.mat'),'file')
    util.dir.updateRemote;
end

clear mainDirectory fid;
% Painter renderer is necessary for saving large SVG files apporpriately
set(0, 'DefaultFigureRenderer', 'painters');

% Turn off excel writing warning
warning('off','MATLAB:xlswrite:AddSheet');