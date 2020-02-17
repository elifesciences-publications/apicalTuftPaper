function [remoteDir] = loadRemote()
%LOADREMOTE Summary of this function goes here
%   Detailed explanation goes here
fname = fullfile(util.dir.getMatfile,'remoteDir.mat');
d = load(fname,'fserverDir');
remoteDir = d.fserverDir;
end

