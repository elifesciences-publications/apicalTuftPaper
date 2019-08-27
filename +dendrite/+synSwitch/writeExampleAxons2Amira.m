%% The shaft seeded tree
outputFolder=fullfile(util.dir.getFig1,'AmiraForSpineTargetingRatio');
util.mkdir(outputFolder);

inputSkel={{'PPC_inhibitoryAxon','singleSpineLumped'},...
    {'PPCspineSeeded_spineRatioMappingL2'}};
treeNames={'inhibitoryAxonLayer2ApicalDendriteSeeded02',...
    'layer2ApicalDendriteSeeded25'};
fnames={'ShaftSeeded','SpineSeeded'};

colors={inhcolor,exccolor};
for i=1:2
    curName=fullfile(outputFolder,fnames{i});
    skel=apicalTuft(inputSkel{i}{:});
    trID=skel.getTreeWithName...
        (treeNames{i});
    skel=skel.deleteTrees(trID,true);
    synCoords{i}=skel.getSynCoord;
    skelTrimmed=skel.getBackBone;
    if ~iscell(synCoords{i}{1,2})
        thisCoord=synCoords{i}{1,2};
        synCoords{i}=[thisCoord;cat(1,synCoords{i}{1,3:end}{:})];
    else
        synCoords{i}=cat(1,synCoords{i}{1,2:end}{:});
    end
    util.amira.convertKnossosNmlToHocAll...
        (skelTrimmed,curName);
    synCoordsNM=synCoords{i}.*skel.scale;
    util.amira.writeSphere(synCoordsNM,1000,[curName,'.ply'],colors{i});
end
system('./synPlots.sht')
%% The spine seeded tree
skel=apicalTuft();
trID=skel.getTreeWithName...
    ('layer2ApicalDendriteSeeded25');
skel=skel.deleteTrees(trID,true);
skel=skel.getBackBone;
