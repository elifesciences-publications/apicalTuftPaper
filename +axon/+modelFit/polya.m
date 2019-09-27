% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% This script does the following:
%       1. Get the synapse counts for different postsynaptic targets of
%           inhibitory axons
%       2. Get the maximum likelihood estimation (MLE) of a
%           Dirichlet-multinomial(Polya)
%           model for the axonal specificites using the fastfit package--see
%           for details https://tminka.github.io/papers/dirichlet/minka-dirichlet.pdf
%       3. Sample from the MLE Polya distribution matching the count of synapses
%           With the actual sample for "numberOfBootstrap" samples
%       4. Get the MLE for each one of these samples and use that to get a
%           estimate of the MLE distribution. That is use the 95% of
%           distribution weight for these bootstrap samples to
%
% You need the lightspeed and fastfit packages. After getting them and
% installing from these two github repositories:
%   lightspeed: https://github.com/tminka/lightspeed/
%   fastfit: https://github.com/tminka/fastfit
% Add the absolute path to these repositories here:
util.clearAll;
lightSpeedDirectory='/home/alik/code/fastfit';
fastFitDirectory='/home/alik/code/lightspeed';
addpath(genpath(lightSpeedDirectory));
addpath(genpath(fastFitDirectory));

% Get the axonal counts
outputDir=fullfile(util.dir.getFig2,'B');
util.mkdir(outputDir);
count = axon.modelFit.getSynapseCountInh;

%% Polya fit model, use the mean of the polya as a estimate for multinimial
%   p parameter which stands for the tendency of an axonal group to target
%   specific targets
% get the sample MLE polya fit
mleAlpha.deep=polya_fit(count.deep);
mleAlpha.layer2=polya_fit(count.layer2);
mleMean=structfun(@(x)x./sum(x),mleAlpha,'UniformOutput',false);
assert(all(structfun(@sum,mleMean)-1<1E-8));
probabilityMatrixForApicals=[mleMean.layer2(1:2);mleMean.deep(1:2)];
% Probability fraction for each apical dendrite target
ADtargetingProb=(probabilityMatrixForApicals./...
    sum(probabilityMatrixForApicals,2));
disp(ADtargetingProb*100)
% Plot probability matrix
util.plot.probabilityMatrix(probabilityMatrixForApicals,...
    fullfile(outputDir,'polyaFit.svg'))
util.plot.probabilityMatrix(ADtargetingProb,...
    fullfile(outputDir,'polyaFitADProb.svg'));
%% Write the probability as a table
probTable {1} = array2table(probabilityMatrixForApicals,'VariableNames',...
    {'L2Target','DeepTarget'},'RowNames',{'L2SeededAxons','DeepSeededAxons'});
probTable {2}= array2table(ADtargetingProb,'VariableNames',...
    {'L2Target','DeepTarget'},'RowNames',{'L2SeededAxons','DeepSeededAxons'});
fnames= {fullfile(outputDir,'probTable.xlsx'),fullfile(outputDir,'probOnlyAD.xlsx')};
for i=1:2
    writetable(probTable{i},fnames{i});
end
util.copyfiles2fileServer