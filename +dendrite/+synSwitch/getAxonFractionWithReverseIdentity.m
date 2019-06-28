% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Note: inhibitory and excitatory in the annotation names is a misnomer 
% since these are Shaft and single-innervated Spine seeded axons
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig1,'AxonReversing');
util.mkdir(outputDir)
seedTypes={'spineSeeded','shaftSeeded'};
layers={'L1','L2'};
tags={'Spine','SpineSinglePlusApicalSingle'};
threshold=0.5;
%% single-spine innervation fraction for axons seeded in Seeded from shaft
% spine structures on the apical dendrites of different pyramidal
% cell-types. L2,3,5 in L1 region and L2 vs L3/5 in L2 region
apTuft.L1=apicalTuft.getObjects('spineRatioMappingL1');
% The [single-innervated] Spine and Shaft seeded synapse ratios in L1
% In L1 L3 and L5 are separated
synRatio.L1=apicalTuft.applyMethod2ObjectArray(apTuft.L1,'getSynRatio',...
    true, false);
synRatio.L1.Properties.VariableNames=seedTypes;
% The [single-innervated] Spine and Shaft seeded synapse ratios in L2
% Separate .nmls
apTuft.L2.(seedTypes{2})=apicalTuft.getObjects('inhibitoryAxon',...
    'singleSpineLumped');
synRatio.L2.(seedTypes{2})= apicalTuft. ...
    applyMethod2ObjectArray...
    (apTuft.L2.(seedTypes{2}),'getSynRatio',true,true).Aggregate; 

apTuft.L2.(seedTypes{1})=apicalTuft.getObjects('spineRatioMappingL2');
synRatio.L2.(seedTypes{1})= apicalTuft. ...
    applyMethod2ObjectArray...
    (apTuft.L2.(seedTypes{1}),'getSynRatio',true,true).Aggregate;
if ~istable(synRatio.L2)
    synRatio.L2=struct2table(synRatio.L2,'RowNames',{'L2','Deep'});
end
%% Get the correction fractions
fractionFun={@(x)sum(x<threshold)/length(x),...
    @(x)sum(x>threshold)/length(x)};
for l=1:2
    curLayer=synRatio.(layers{l});
    for synapseSeedType=1:2
        curSeedT=curLayer.(seedTypes{synapseSeedType});
        for apTypeSeed=1:length(curSeedT)
            if ~contains(cell2mat...
                    (curSeedT{apTypeSeed}.Properties.VariableNames),...
                    'SpineSinglePlusApicalSingle')
                curResult.(seedTypes{synapseSeedType})(apTypeSeed,1)=...
                    fractionFun{synapseSeedType}(curSeedT{apTypeSeed}.(tags{1}));
            else
                curResult.(seedTypes{synapseSeedType})(apTypeSeed,1)=...
                    fractionFun{synapseSeedType}(curSeedT{apTypeSeed}.(tags{2}));
            end
        end
    end
    axonSwitchFraction.(layers{l})=struct2table(curResult,...
        'RowNames',curLayer.Properties.RowNames);
    curResult=[];
end
% Save the output for later retrieval
save(fullfile(util.dir.getAnnotation,'matfiles','axonSwitchFraction'),...
    'axonSwitchFraction')
