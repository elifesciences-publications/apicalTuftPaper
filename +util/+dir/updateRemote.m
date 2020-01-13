function [] = updateRemote()
% UPDATEREMOTE Update remote directory for copying image files 
% Note: The use case is for copying figures to a shared file server for
% access from another machine

fserverDir = inputdlg('Enter the remote directory for figure panels to be copied to:',...
    'Remote directory');
fserverDir = fserverDir{1};
if isempty(fserverDir)
    disp ('Empty remote directory: Figures are not copied to a remote directory');
    disp ('Update using util.dir.updateRemote')
end
% Save dir to matfile
fname = fullfile(util.dir.getMatfile,'remoteDir.mat');
save(fname, 'fserverDir');

end

