%% TODO: need to save out the bboxT for later reading of the volumes
% Also need to be done for V2. Before this make sure you have the correct
% version of old annotation in that case also create unique folders for
% each version of dataset
bifurcationCenters={[5126, 6644, 992],[3202, 5332, 2783],...
    [3687, 5111, 2733],[5704, 6238, 1367]};
% get Bounding Boxes
wkBboxes=cellfun(@(c) util.getBoxFromCenSize(c,20,[12,12,30]).WK,centers,...
    'UniformOutput',false);
matlabBboxes=cellfun(@(c) util.getBoxFromCenSize(c,20,[12,12,30]).matlab,centers,...
    'UniformOutput',false);
% Define Directories and nml names
mainDir=fullfile(util.dir.getAnnotation,'isoSurfaceGeneration','acc',...
    'JO_ACC_Z_version');
nmlFile.name='ACC_volumeAnnotations_1.nml';
nmlFile.dir=fullfile(mainDir,'ACC_volumeAnnotations_1Raw');
prepareVolAnnotation=[0,0,0,1];
Ids=[1,1,4,1];
% Cleanup the directory before writing anything
try
    rmdir(fullfile(nmlFile.dir,'Straight'),'s')
catch
    disp(['Dir already deleted: ',fullfile(nmlFile.dir,'Straight')])
end
bboxT=cell(1,4);
for i=1:4
    processData.flag=false;
    processData.cellID=Ids(i);
    processData.newCellID=i;
    vol=surface.genIsosurface.readVolume(mainDir,['ACC_volumeAnnotations_',num2str(i)],...
        matlabBboxes{i},processData);
    % Restrict to minimal bbox
    [vol,newBboxGlobal]=...
        surface.genIsosurface.restrict2MinimalBbox(vol,matlabBboxes{i});
    assert(any(vol(:)), 'Make sure volume is not empty')
    % Correct the volume
    load(fullfile(util.dir.getSurface, ...
        'shifts_JO_ACC_Z_straightenedPosthoc'));
    [volT,bboxT{i}] = surface.convertVolStraight.applyToRaw...
        (vol,magShifts,newBboxGlobal);
    clear vol
    [volT,bboxT{i}]=surface.genIsosurface.restrict2MinimalBbox(volT,bboxT{i});
    % Write it out
    surface.genIsosurface.writeVolume(volT,bboxT{i},...
        fullfile(nmlFile.dir,'Straight'),nmlFile,prepareVolAnnotation(i))
end