%% Fig. 4: Coefficient of Variation (CV) for average axonal innervation between cortical region
% These numbers are reported for reinnervation L2, DL AD and L2 somas

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

%% Setup
util.clearAll;
outputFolder = fullfile(util.dir.getFig(4),'BC');
util.mkdir(outputFolder);

%% Get annotations
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio = synRatio{:,1:4};

%% Get the Coefficient of Varaiation (CV)
fun = @(x) mean(x{:,2:end},1);
theMeans = cellfun(fun, synRatio,'UniformOutput',false);
% Concatenate means from different datasets
L2SeededMeans = cat(1,theMeans{1,:});
deepSeededMeans = cat(1,theMeans{2,:});
% Get Coefficient of varaiation
CV.L2seeded = util.stat.coeffVar(L2SeededMeans,1)';
CV.Deepseeded = util.stat.coeffVar(deepSeededMeans,1)';

targetNames = synRatio{1,1}.Properties.VariableNames(2:end);
writetable(struct2table(CV,'RowNames',targetNames), fullfile(outputFolder, ...
    'CoefficientOfVariation.xlsx'),'WriteRowNames',true);
