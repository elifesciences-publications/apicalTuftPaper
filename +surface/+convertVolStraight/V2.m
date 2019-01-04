bboxes={[3260,951,2472,1664,1664,668],[4980,967,3518,1664,1664,668],...
    [5034,467,3782,1664,1664,668],[3171,633,3823,1664,1664,668 ]};
%Get all the bboxes chopped into sizes which are downloadable from WK
matlabBboxes=cellfun(@Util.convertWebknossosToMatlabBbox,bboxes,...
    'UniformOutput',false);
mainDir=fullfile(util.dir.getSurface,'v2',...
    'V2_102_l23_ak_sift_v2_halfminusshifti_version');
nmlFile.name='V2_volumeAnnotations.nml';
nmlFile.dir=fullfile(mainDir,'V2_volumeAnnotationsRaw');
prepareVolAnnotation=[0,0,0,1];
% Cleanup the directory before writing anything
try
    rmdir(fullfile(nmlFile.dir,'Straight'),'s')
catch
    disp(['Directory already deleted: ',fullfile(nmlFile.dir,'Straight')])
end

bboxT=cell(1,4);
for i=1:4
    processData.flag=false;
    processData.cellID=i;
    processData.newCellID=i;
    vol=surface.genIsosurface.readVolume(mainDir,'V2_volumeAnnotations',...
        matlabBboxes{i},processData);
    % Restrict to minimal bbox
    [vol,newBboxGlobal]=...
        surface.genIsosurface.restrict2MinimalBbox(vol,matlabBboxes{i});
    
    % Correct the volume
    load(fullfile(util.dir.getSurface, ...
        'shifts_V2_102_l23_ak_straightenedPosthoc'));
    [volT,bboxT{i}] = surface.convertVolStraight.applyToRaw...
        (vol,magShifts,newBboxGlobal);
    clear vol
    [volT,bboxT{i}]=surface.genIsosurface.restrict2MinimalBbox(volT,bboxT{i});
    % Write it out
    surface.genIsosurface.writeVolume(volT,bboxT{i},...
        fullfile(nmlFile.dir,'Straight'),nmlFile,prepareVolAnnotation(i))
end