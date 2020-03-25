%% Fig. 4: Coefficient of Variation (CV) for average axonal innervation between cortical region
% These numbers are reported for reinnervation L2, DL AD and L2 somas
%% Setup
util.clearAll;
outputFolder = fullfile(util.dir.getFig(4),'BC');
util.mkdir(outputFolder);
apTuft = apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
synRatio = synRatio{:,1:4};

fun = @(x) mean(x{:,2:end},1);
theMeans = cellfun(fun, synRatio,'UniformOutput',false);
% Get the means for each cortical region
L2Means = cat(1,theMeans{1,:});
deepMeans = cat(1,theMeans{2,:});
% Get CV
CV.l2 = util.stat.coeffVar(L2Means,1)';
CV.Deep = util.stat.coeffVar(deepMeans,1)';
writetable(struct2table(CV), fullfile(outputFolder, ...
    'CoefficientOfVariation.txt'));
