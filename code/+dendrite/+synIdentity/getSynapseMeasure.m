function [synapseMeasure] = getSynapseMeasure(func)
%GETALLSYNRATIOS retursn the synapse property described by the function
if ~exist('func','var') || isempty(func)
    func = 'getSynRatio';
end
if any(strcmp(func,{'getSynRatio','getSynCount'}))
    fixRatioValues = true;
else
    fixRatioValues = false;
end
seedTypes={'Spine','Shaft'};
%% Get synapse single-spine innervation ratios
% single-spine innervation fraction for axons seeded from shaft
% and spine structures on the apical dendrites of different pyramidal
% cell-types. L2, 3, 5 in L1 region and L2 vs L3/5 in L2 region (small datasets)
apTuft.L1=apicalTuft.getObjects('spineRatioMappingL1');
% The [single-innervated] Spine and Shaft seeded synapse ratios in L1
% In L1, L3 and L5 neuron groups are separated
synapseMeasure.L1=apicalTuft.applyMethod2ObjectArray(apTuft.L1,func,...
    true, false);
synapseMeasure.L1.Properties.VariableNames=seedTypes;
% The [single-innervated] Spine and Shaft seeded synapse ratios in L2
% Separate .nmls
apTuft.L2.(seedTypes{1}) = apicalTuft.getObjects('spineRatioMappingL2');
apTuft.L2.(seedTypes{2}) = apicalTuft.getObjects('inhibitoryAxon',...
    'singleSpineLumped');
for i=1:2
    synapseMeasure.L2.(seedTypes{i})= apicalTuft. ...
        applyMethod2ObjectArray...
        (apTuft.L2.(seedTypes{i}),func,true,true).Aggregate;
end
if ~istable(synapseMeasure.L2)
    synapseMeasure.L2=struct2table(synapseMeasure.L2,'RowNames',{'L2','Deep'});
end
%% Add L5A single-spine innervation Ratio
apTuft.L5A=apicalTuft.getObjects('L5ARatioMapping');
l5ARatio=cellfun(@(x) x.(func),apTuft.L5A,'UniformOutput',false);
% In distalAD (L1) annotations. Note the spine fraction we just use the L5B
% fractions
synapseMeasure.L1=[synapseMeasure.L1;...
    {synapseMeasure.L1{'deepLayerApicalDendriteSeeded',1},l5ARatio{1}}];
synapseMeasure.L1.Properties.RowNames{end}='layer5AApicalDendriteSeeded';
% In Bifurcation annotations. Use Deep annotations for the spine switch
% fraction
synapseMeasure.L2=[synapseMeasure.L2;...
    {synapseMeasure.L2{'Deep',1},l5ARatio{2}}];
synapseMeasure.L2.Properties.RowNames{end}='L5A';

%% Fix the shaft seeded axons in L2
if fixRatioValues
    for i=1:2
        synapseMeasure.L2.(seedTypes{2}){i}=...
            dendrite.synIdentity.fixShaftSeededL2Table...
            (synapseMeasure.L2.(seedTypes{2}){i});
    end
end
end

