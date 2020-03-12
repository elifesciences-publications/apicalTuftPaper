% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set-up
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig(1),'AxonReversing');
util.mkdir(outputDir)
seedTypes={'Spine','Shaft'};
saveMatfile=false;
%% Get all the synapse ratios:
synRatio=dendrite.synIdentity.getSynapseMeasure('getSynRatio');
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
numFun = {@(x) [sum(x<threshold),length(x)],...
    @(x) [sum(x>threshold),length(x)]};
numForReport = [];
% Loop through layers, seed type (spine vs. shaft) and apical type
for l=1:2
    curLayer=synRatio.(layers{l});
    for synapseSeedType=1:2
        curSeedT=curLayer.(seedTypes{synapseSeedType});
        seedType=seedTypes{synapseSeedType};
        for apTypeSeed=1:length(curSeedT)
            spInnervationFraction=curSeedT{apTypeSeed}.Spine;
            curFun = fractionFun{synapseSeedType};
            curResult.(seedType)(apTypeSeed,1)=...
                    curFun(spInnervationFraction);
            numForReport = [numForReport;numFun{synapseSeedType}(spInnervationFraction)];
        end
    end
    axonSwitchFraction.(layers{l})=struct2table(curResult,...
        'RowNames',curLayer.Properties.RowNames);
    curResult=[];
end
axonSwitchFraction=structfun(@(x)fliplr(x),axonSwitchFraction,...
    'UniformOutput',false);
%% Save the output for later retrieval
if saveMatfile
    save(fullfile(util.dir.getAnnotation,'matfiles','axonSwitchFraction'),...
        'axonSwitchFraction');
end
textFileName=fullfile(util.dir.getFig(3),'correctionforAxonSwitching',...
    'axonSwitchFraction');
f=fieldnames(axonSwitchFraction);
for i=1:length(f)
    axonSwitchFraction.(f{i}).Variables=...
        round(axonSwitchFraction.(f{i}).Variables*100,2);
    writetable(axonSwitchFraction.(f{i}),...
        [textFileName,'_',f{i},'.xlsx'],'WriteRowNames',true);
end
system('./synPlots.sht');

%% Total number of axons involved for the text
% Use this section to get the total number of axons involved in the identity 
% correction fractions. Number used in methods, figure legends
synRatioNoL5ASpine = synRatio;
for i=1:2
    synRatioNoL5ASpine.(layers{i}){end,'Spine'}={table()};
    totalSynNumbers = cellfun(@height,...
        synRatioNoL5ASpine.(layers{i}).Variables);
    disp(sum(totalSynNumbers,'all'))
end

%% Report the total error rate by combining all the data 
% (reviewer response letter)

numForReport([4,11],:) = [];
summed = sum(numForReport,1);
fractionOfAxonsFromTotal = summed(1)/summed(2);
disp (fractionOfAxonsFromTotal);

%% Number of synapses per axon
synCount = dendrite.synIdentity.getSynapseMeasure('getTotalSynapseNumber');
% Remove duplicates for L5A
synCount.L2{3,1}{1}=[];
synCount.L1{4,1}{1}=[];

