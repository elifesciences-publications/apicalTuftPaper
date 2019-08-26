function [synRatio] = getAllSpineRatios()
%GETALLSYNRATIOS retursn the syna
seedTypes={'Spine','Shaft'};
%% Get synapse single-spine innervation ratios
% single-spine innervation fraction for axons seeded from shaft
% and spine structures on the apical dendrites of different pyramidal
% cell-types. L2, 3, 5 in L1 region and L2 vs L3/5 in L2 region (small datasets)
apTuft.L1=apicalTuft.getObjects('spineRatioMappingL1');
% The [single-innervated] Spine and Shaft seeded synapse ratios in L1
% In L1, L3 and L5 neuron groups are separated
synRatio.L1=apicalTuft.applyMethod2ObjectArray(apTuft.L1,'getSynRatio',...
    true, false);
synRatio.L1.Properties.VariableNames=seedTypes;
% The [single-innervated] Spine and Shaft seeded synapse ratios in L2
% Separate .nmls
apTuft.L2.(seedTypes{1})=apicalTuft.getObjects('spineRatioMappingL2');
apTuft.L2.(seedTypes{2})=apicalTuft.getObjects('inhibitoryAxon',...
    'singleSpineLumped');
for i=1:2
    synRatio.L2.(seedTypes{i})= apicalTuft. ...
        applyMethod2ObjectArray...
        (apTuft.L2.(seedTypes{i}),'getSynRatio',true,true).Aggregate;
end
if ~istable(synRatio.L2)
    synRatio.L2=struct2table(synRatio.L2,'RowNames',{'L2','Deep'});
end
% Fix the inhibotry axon
for i=1:2
synRatio.L2.(seedTypes{2}){i}=...
    dendrite.synSwitch.fixShaftSeededL2Table...
    (synRatio.L2.(seedTypes{2}){i});
end

%% Add L5A single-spine innervation Ratio
apTuft.L5A=apicalTuft.getObjects('L5ARatioMapping');
l5ARatio=cellfun(@(x) x.getSynRatio,apTuft.L5A,'UniformOutput',false);
% In distalAD (L1) annotations. Note the spine fraction we just use the L5B
% fractions
synRatio.L1=[synRatio.L1;...
    {synRatio.L1{'deepLayerApicalDendriteSeeded',1},l5ARatio{1}}];
synRatio.L1.Properties.RowNames{end}='layer5AApicalDendriteSeeded';
% In Bifurcation annotations. Use Deep annotations for the spine switch
% fraction
synRatio.L2=[synRatio.L2;...
    {synRatio.L2{'Deep',1},l5ARatio{2}}];
synRatio.L2.Properties.RowNames{end}='L5A';
end

