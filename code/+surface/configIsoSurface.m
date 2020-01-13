function [param] = configIsoSurface(dataset)
% configIsoSurface This function just outputs the some parameters for the isosurface
% generation.
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

param.mainDir=fullfile(util.dir.getAnnotation,'isoSurfaceGeneration');
param.(dataset).datasetDir=fullfile(param.mainDir,dataset);
param.(dataset).allparamFile=fullfile(param.(dataset).datasetDir,'allParameter.mat');
param.(dataset).MergerNml=fullfile(param.(dataset).datasetDir,[dataset,'MergerMode.nml']);
% Load the parameter if it exists
if exist(param.(dataset).allparamFile,'file')
    p=load(param.(dataset).allparamFile,'-mat','p');
    param.(dataset).p=p.p;
end

if strcmp(dataset,'s1')
    param.s1.p.seg.root='/tmpscratch/webknossos/Connectomics_Department/2012-11-23_ex144_st08x2New/segmentation/1';
    param.s1.p.seg.backend='wkwrap';
    param.s1.p.raw.voxelSize=[11.24,11.24,28];
    param.s1.bifurcationCenter={[5387, 4958, 569],[2820, 3117, 6069],...
    [4158, 4378, 6017],[3183, 4045, 7064]};
    param.treeNames={'layer2ApicalDendrite01','layer2ApicalDendrite09',...
    'deepLayerApicalDendrite05','deepLayerApicalDendrite06'};
end
if strcmp(dataset,'ppc')
    param.ppc.bifurcationCenter={[2064, 3845, 4495],[1532, 4128, 3851],...
    [2835, 2358, 3410],[743, 5908, 2875]};
    param.treeNames={'deepLayerApicalDendrite09','deepLayerApicalDendrite10',...
    'layer2ApicalDendrite03','layer2ApicalDendrite05'};
end

end

