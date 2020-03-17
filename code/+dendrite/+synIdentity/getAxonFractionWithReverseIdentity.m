% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set-up
util.clearAll;
outputDir = fullfile(util.dir.getFig(2),'B');
util.mkdir(outputDir)
seedTypes = {'Spine','Shaft'};

%% Get all the synapse ratios:
synRatio = dendrite.synIdentity.getSynapseMeasure('getSynRatio');

%% Get the correction fractions
layers = {'L1','L2'};
% Threshhold and anom function for gettting fraction of spine-seeded 
% and shaft seeded axons which switch their identity. This means for a
% shaft-seeded axon to have a single-spine innervation larger than 0.5 and
% for a spine-seeded axon to have single-spine innervation of smaller than
% 0.5
threshold = 0.5;
fractionFun = {@(x)sum(x<threshold)/length(x),...
    @(x)sum(x>threshold)/length(x)};
numFun  =  {@(x) [sum(x<threshold),length(x)],...
    @(x) [sum(x>threshold),length(x)]};
numForReport  =  [];
% Loop through layers, seed type (spine vs. shaft) and apical type
for l = 1:2
    curLayer = synRatio.(layers{l});
    for synapseSeedType = 1:2
        curSeedT = curLayer.(seedTypes{synapseSeedType});
        seedType = seedTypes{synapseSeedType};
        for apTypeSeed = 1:length(curSeedT)
            spInnervationFraction = curSeedT{apTypeSeed}.Spine;
            curFun  =  fractionFun{synapseSeedType};
            curResult.(seedType)(apTypeSeed,1) = ...
                    curFun(spInnervationFraction);
            numForReport  =  [numForReport;numFun{synapseSeedType}(spInnervationFraction)];
        end
    end
    axonSwitchFraction.(layers{l}) = struct2table(curResult,...
        'RowNames',curLayer.Properties.RowNames);
    curResult = [];
end
axonSwitchFraction = structfun(@(x)fliplr(x),axonSwitchFraction,...
    'UniformOutput',false);

%% Save the output for later retrieval
saveMatfile = false;
if saveMatfile
    save(fullfile(util.dir.getMatfile,'axonSwitchFraction'),...
        'axonSwitchFraction');
end
textFileName = fullfile(outputDir,...
    'axonSwitchFraction');
f = fieldnames(axonSwitchFraction);
for i = 1:length(f)
    axonSwitchFraction.(f{i}).Variables = ...
        round(axonSwitchFraction.(f{i}).Variables*100,2);
    writetable(axonSwitchFraction.(f{i}),...
        [textFileName,'_',f{i},'.xlsx'],'WriteRowNames',true);
end