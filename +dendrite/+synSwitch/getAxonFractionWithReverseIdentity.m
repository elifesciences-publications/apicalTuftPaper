% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig1,'AxonReversing');
util.mkdir(outputDir)
seedTypes={'Spine','Shaft'};
saveMatfile=true;
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
%% Get the correction fractions
layers={'L1','L2'};
% Threshhold and anom function for gettting fraction of spine-seeded 
% and shaft seeded axons which switch their identity. This means for a
% shaft-seeded axon to have a single-spine innervation larger than 0.5 and
% for a spine-seeded axon to have single-spine innervation of smaller than
% 0.5
threshold=0.5;
fractionFun={@(x)sum(x<threshold)/length(x),...
    @(x)sum(x>threshold)/length(x)};
% Loop through layers, seed type (spine vs. shaft) and apical type
for l=1:2
    curLayer=synRatio.(layers{l});
    for synapseSeedType=1:2
        curSeedT=curLayer.(seedTypes{synapseSeedType});
        seedType=seedTypes{synapseSeedType};
        for apTypeSeed=1:length(curSeedT)
            spInnervationFraction=curSeedT{apTypeSeed}.Spine;
            curFun=fractionFun{synapseSeedType};
            curResult.(seedType)(apTypeSeed,1)=...
                    curFun(spInnervationFraction);
        end
    end
    axonSwitchFraction.(layers{l})=struct2table(curResult,...
        'RowNames',curLayer.Properties.RowNames);
    curResult=[];
end
axonSwitchFraction=structfun(@(x)fliplr(x),axonSwitchFraction,...
    'UniformOutput',false);
% Save the output for later retrieval
if saveMatfile
    save(fullfile(util.dir.getAnnotation,'matfiles','axonSwitchFraction'),...
        'axonSwitchFraction')
end