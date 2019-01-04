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
outputDir=fullfile(util.dir.getFig2,'A');
util.mkdir(outputDir);
count=axon.modelFit.getSynapseCountInh;

%% Polya fit model, use the mean of the polya as a estimate for multinimial 
%   p parameter which stands for the tendency of an axonal group to target
%   specific targets
% get the sample MLE polya fit
mleAlpha.deep=polya_fit(count.deep);
mleAlpha.layer2=polya_fit(count.layer2);
mleMean=structfun(@(x)x./sum(x),mleAlpha,'UniformOutput',false);
assert(all(structfun(@sum,mleMean)-1<1E-8));
probabilityMatrixForApicals=[mleMean.layer2(1:2);mleMean.deep(1:2)];

% Plot probability matrix
t(probabilityMatrixForApicals,...
fullfile(outputDir,'polyaFit.svg'))
disp(probabilityMatrixForApicals)
%% Bootstrap sampling from the Polya distribution
mleAlpha.layer2=polya_fit(count.deep);
mleAlpha.deep=polya_fit(count.layer2);
numberOfBootstrap=10000;
alphaMLEL2_BS=zeros(numberOfBootstrap,length(dlAlphaSample));
alphaMLEDL_BS=zeros(numberOfBootstrap,length(l2AlphaSample));
parfor sample=1:numberOfBootstrap
    curBootStrapSampleL2=axon.modelFit.bootStrapSample...
        (l2AlphaSample,count.layer2);
    curBootStrapSampleDL=axon.modelFit.bootStrapSample...
        (dlAlphaSample,count.deep);
    Get the MLE of the bootstrap sample 
    alphaMLEL2_BS(sample,:)=polya_fit(curBootStrapSampleL2);
    alphaMLEDL_BS(sample,:)=polya_fit(curBootStrapSampleDL);
    disp(['sample done: ',num2str(sample)]);
end
save(fullfile(outputDir,'theMLEEstimatesOfDirichletMultinomial'),...
    'alphaMLEL2_BS','alphaMLEDL_BS');
%   For each MLE find the mean of the dirichlet part giving us the mean
%   binomial parameter
binomialp_MLEL2_BS=alphaMLEL2_BS./sum(alphaMLEL2_BS,2);
binomialp_MLEDL_BS=alphaMLEDL_BS./sum(alphaMLEDL_BS,2);
% Check the multinial always sums up to one
assert(all(sum(binomialp_MLEL2_BS,2)-1<1e-8));
assert(all(sum(binomialp_MLEDL_BS,2)-1<1e-8));

meansL2=mean(binomialp_MLEL2_BS,1);
errorL2=diff(prctile(binomialp_MLEL2_BS,[0.05 0.95],1),1)./2;
meansDL=mean(binomialp_MLEDL_BS,1);
errorDL=diff(prctile(binomialp_MLEDL_BS,[0.05 0.95],1),1)./2;

fh=figure;ax=gca;
x_width=24;
y_width=14;
hold on
errorbar(meansL2,errorL2,'Color',l2color);
errorbar(meansDL,errorDL,'Color',dlcolor);
outputDir='/mnt/mpibr/data/Data/karimia/presentationsWriting/Talks/progressReport06082018/'
xticklabels({'L2Apical','DeepApical','Soma','Shaft','SpineDouble','SpineSingle','AIS','Glia'});
xtickangle(-45)
ylim([0 1]);
xlim([0.5 length(meansDL)+0.5]);
ylabel('PolyaFit parameter');
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'PolyaFitModel');



deepPolyaFitALphaSample=dlAlphaSample./sum(dlAlphaSample);
l2PolyaFitALphaSample=l2AlphaSample./sum(l2AlphaSample);
fh=figure;ax=gca;
x_width=20;
y_width=20;
hold on
plot(l2AlphaSample,'Color',l2color);
plot(dlAlphaSample,'Color',dlcolor);

xticklabels(synCount{1,1}(:,[2,3,5,6,7,4,8,9]).Properties.VariableNames);
xtickangle(-45)
ylim([0 1]);
ylabel('Mean of Polya model')
xlim([0.5 length(means)+0.5]);
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'polyaModel');
