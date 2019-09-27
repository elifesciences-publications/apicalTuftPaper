% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% This script gets a maximum likelihood estimation of the multinomial model
% This is simply the fraction of each target type of the total number of
% synapses. For details of multinomial MLE see:
%       http://statweb.stanford.edu/~susan/courses/s200/lectures/lect11.pdf
% and then uses bootstrap sampling from that MLE to get a estimate of variab
% Get the axonal counts
util.clearAll;
outputDir=fullfile(util.dir.getFig2,'A');
util.mkdir(outputDir);
count=axon.modelFit.getSynapseCountInh;

apTuft=apicalTuft.getObjects('inhibitoryAxon');
synCount=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');
count.layer2=synCount{1,5}{1}{:,2:end};
count.deep=synCount{2,5}{1}{:,2:end};
%% multinomial MLE = fractions
sumOverAxons.layer2=sum(count.layer2,1);
sumOverAxons.deep=sum(count.deep,1);
mleP.layer2=sumOverAxons.layer2./sum(sumOverAxons.layer2);
mleP.deep=sumOverAxons.deep./sum(sumOverAxons.deep);
probabilityMatrixForApicals=[mleP.layer2(1:2);mleP.deep(1:2)];

% Plot probability matrix
util.plot.probabilityMatrix(probabilityMatrixForApicals,...
fullfile(outputDir,'multinomialFit.svg'))


%% Getting the error bars for MLE estimation
numberOfSamples=10000;
bootStrapSampleL2=mnrnd(sum(sumLayer2),mle.layer2,numberOfSamples);
mleBootStrapL2=bootStrapSampleL2./sum(bootStrapSampleL2,2);
meansL2=mean(mleBootStrapL2,1);
errorL2=diff(prctile(mleBootStrapL2,[0.05 0.95],1),1)./2;

bootStrapSampleDL=mnrnd(sum(sumDeep),mle.deep,numberOfSamples);
mleBootStrapDL=bootStrapSampleDL./sum(bootStrapSampleDL,2);
meansDL=mean(mleBootStrapDL,1);
errorDL=diff(prctile(mleBootStrapDL,[0.05 0.95],1),1)./2;


fh=figure;ax=gca;
x_width=20;
y_width=20;
hold on
errorbar(meansL2,errorL2,'Color',l2color);
errorbar(meansDL,errorDL,'Color',dlcolor);
xticklabels(synCount{1,1}(:,[2,3,5,6,7,4,8,9]).Properties.VariableNames);
xtickangle(-45)
ylim([0 1]);
xlim([0.5 length(means)+0.5]);
ylabel('Multinomial parameter');
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'MultinomialModel');




