skel=apicalTuft('LPtA_l2vsl3vsl5');
skelDiam=apicalTuft('LPtA_l2vsl3vsl5Diameter');
% get the backBone:
skelTrimmed=skel.getBackBone([],[],[],true);
skelTrimmed=skelTrimmed.sortTreesByName;
% rename to dist2soma for later merging with the highres mapping cropouts
skelTrimmed.names=strrep(skelTrimmed.names,'mapping','dist2soma');

% CropoutLowres
skelCropped=skel.cropoutLowRes([],3,2768);
skelDiamCropped=skelDiam.cropoutLowRes([],3,2768);

%% Compare backbone of the dense synapse annotations with diameter
% measurements: they should match since they are the same annotations
skelCroppedBackBone=skelCropped.getBackBone;
hold on
fh=figure('units','normalized','outerposition',[0 0 1 1]);
skelCroppedBackBone.plot([],[1,0,1]);
daspect([1,1,1]);view([90,0]);
skelDiamCropped.plot([],[0,1,1]);
hold off
%% Rename the cropped trees
counter=ones(10,3);
cellTypeIndices=[0,1,2,0,3];
for trDense=1:length(skelCropped.names)
    curName=skelCropped.names{trDense};
    trDiam=skelDiamCropped.getTreeWithName(curName);
    % Get the cell type and the ID of tree within each cell type group
    curStrs=strsplit(curName,'_');
    curCellType=regexp(curStrs{1},'layer(\d)','tokens');
    curID=regexp(curStrs{2},'mapping(\w*)','tokens');
    curCellType=str2double(curCellType{1}{1});curID=str2double(curID{1}{1});
    curCellTypeIndex=cellTypeIndices(curCellType);
    newName=strjoin({curStrs{1},curStrs{2},...
        sprintf('%0.2u',counter(curID,curCellTypeIndex))},'_');
    % Update the names
    skelCropped.names{trDense}=newName;
    skelDiamCropped.names{trDiam}=newName;
    % Keep track of the subID of the branch within each tree
    counter(curID,curCellTypeIndex)=counter(curID,curCellTypeIndex)+1;
end
%% Check that tree names match between the diameter and the dense
% Get the Index of diameter trees that match the dense tree Order
[~,locDiam]=ismember(skelCropped.names,skelDiamCropped.names);
assert(isequal(skelCropped.names,skelDiamCropped.names(locDiam)));
% Sort tree names
skelCropped=skelCropped.sortTreesByName;
skelDiamCropped=skelDiamCropped.sortTreesByName;
% Plot trees with matching names
for tr=1:skelCropped.numTrees
    fh=figure('Name',skelCropped.names{tr},...
        'units','normalized','outerposition',[0 0 1 1]);
    skelCropped.plot(tr,[0,1,1]);
    skelDiamCropped.plot(tr,[1,0,1]);
    view([90,0]);
    daspect([1,1,1]);
    uiwait(fh);
end
%% Write nml files
% Combine the backbone of the full dendrite tracings with the dense
% reconstruction crop outs to genereate LPtA_l2vsl3vsl5
combinedDenseSkel=...
    skelTrimmed.addTreeFromSkel(skelCropped,[1:skelCropped.numTrees]);
combinedDenseSkel.write;
% Write out the crop out of the diameter measurements
skelDiamCropped.write