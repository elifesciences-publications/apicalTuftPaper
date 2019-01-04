%% Creating the nml for random synapese location, spine and shaft
clear all
config(false)
outputDir=fullfile(bifur.dir,'synapseSizeComparison');
synapseCoord=bifur.datasetFun(info,names,'getSynCoordComment');

newIteration=true;
%% Get random synapse coordinates
synPerTree=1;
skel=cell(1,4);
%Decide whether get new coordintaes
if newIteration
    randomSynapses=dendrite.synSize.getRandomSynapses(synapseCoord,synPerTree);
else
    load(fullfile(outputDir,'randomSynapseCoordinates.mat'))
end
%% Write them back into the skeleton as 2 trees with 1 voxel location
%Load skeletons into a cell array
for dataset=1:4
    skel{dataset}=skeleton(info.(names{dataset}).tenUm.nmlName);
end

bifur.synSize.writeSynLocationAsTree(skel,randomSynapses,names,outputDir)
save(fullfile(outputDir,addDateToName('randomSynapseCoordinates')),'randomSynapses');


