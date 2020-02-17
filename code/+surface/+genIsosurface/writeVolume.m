function [] = writeVolume(data,bbox,mainDir,nmlFile,prepareVolumeAnnotation)
% Function to write volume annotation from 3D data
% Note: an example auxiliary NML file is necessary
util.mkdir(mainDir);
wkwPath=fullfile(mainDir,'1');
if prepareVolumeAnnotation
    surface.genIsosurface.writeVolByBlock...
        (wkwPath, bbox, uint32(data));
    % Zip
    dataFile=fullfile(mainDir,'data.zip');
    zip(dataFile,wkwPath);
    rmdir(wkwPath,'s');
    % Copy the nmlfile over from older tracing
    fullNmlName=fullfile(mainDir,nmlFile.name);
    copyfile(fullfile(nmlFile.dir,nmlFile.name),fullNmlName);
    disp('V2_102_l23_ak_straightenedPosthoc or JO_ACC_Z_straightenedPosthoc')
    disp(['Now is the time to correct the dataset name nmlFile in: ',mainDir]) 
    disp('write "dbcont" to continue')
    keyboard
    fullZipName=fullNmlName;
    fullZipName(end-2:end)='zip';
    zip(fullZipName,{fullNmlName,dataFile});
else
    surface.genIsosurface.writeVolByBlock...
        (wkwPath, bbox, uint32(data));
end
end