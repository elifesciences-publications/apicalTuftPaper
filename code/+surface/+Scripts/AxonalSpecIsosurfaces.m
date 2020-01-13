% This is a relatively old script for creating the isosurfaces for the
% Suppl. Fig2a
% Setting up
% Note to Self: all relevant files are now in the following dir:
% '/home/alik/code/alik/L1paper/annotationData/isoSurfaceGeneration/ppc/Fig2'
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% This part is run on our compute cluster, Gaba. 
% It generates the isosurfaces
load('/tmpscratch/alik/pipelineRunApril2017/allParameter.mat');
addpath(genpath(pwd))

nmlDir='/gaba/u/alik/Data/L1Paper/';
nmlNames={'Axons_MergerMode_fig2a','DL_Apical_MergerModeFig2a',...
    'L2_Apical_MergerModeFig2a_onlyApical'};
for nmlId=1:3
nmlName=fullfile(nmlDir,[nmlNames{nmlId},'.nml']);
Visualization.exportNmlToAmira(p,nmlName,...
    fullfile('/tmpscratch/alik/',nmlNames{nmlId},'/'),...
    'smoothSizeHalf',4,'smoothWidth',8,'reduce',0.1);
end

%% Write the location of synapses for cyan spheres
outputFolder=fullfile(util.dir.getSurface,'ppc','Fig2');
util.mkdir(outputFolder);
skel=apicalTuft('PPC2017_inhibitoryAxon');
treeNames={'inhibitoryAxonDeepLayerApicalDendriteSeeded10',...
    'inhibitoryAxonLayer2ApicalDendriteSeeded21'};
skel.synCenterTPA=true;
skel=skel.deleteTrees(skel.getTreeWithName(treeNames,'exact'),true);
skel.writeSynCoordinateTextFile([],outputFolder,'cyan',true);

%% Visualization test
f=rdir(fullfile(outputFolder,'isosurfaces/**/*.ply'));
for i=1:length(f)
    isoSurf{i}=Visualization.readPLY(f(i).name);
end
skel.plotSynapses;
skel.plot;
cellfun(@surface.draw,isoSurf);