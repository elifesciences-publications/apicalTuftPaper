%% Bootstrap sampling from the Polya distribution
mleAlpha.layer2 = polya_fit(count.deep);
mleAlpha.deep = polya_fit(count.layer2);
numberOfBootstrap = 10000;
alphaMLEL2_BS = zeros(numberOfBootstrap,length(dlAlphaSample));
alphaMLEDL_BS = zeros(numberOfBootstrap,length(l2AlphaSample));
parfor sample = 1:numberOfBootstrap
    curBootStrapSampleL2 = axon.modelFit.bootStrapSample...
        (l2AlphaSample,count.layer2);
    curBootStrapSampleDL = axon.modelFit.bootStrapSample...
        (dlAlphaSample,count.deep);
    Get the MLE of the bootstrap sample
    alphaMLEL2_BS(sample,:) = polya_fit(curBootStrapSampleL2);
    alphaMLEDL_BS(sample,:) = polya_fit(curBootStrapSampleDL);
    disp(['sample done: ',num2str(sample)]);
end
save(fullfile(outputDir,'theMLEEstimatesOfDirichletMultinomial'),...
    'alphaMLEL2_BS','alphaMLEDL_BS');
%   For each MLE find the mean of the dirichlet part giving us the mean
%   binomial parameter
binomialp_MLEL2_BS = alphaMLEL2_BS./sum(alphaMLEL2_BS,2);
binomialp_MLEDL_BS = alphaMLEDL_BS./sum(alphaMLEDL_BS,2);
% Check the multinial always sums up to one
assert(all(sum(binomialp_MLEL2_BS,2)-1<1e-8));
assert(all(sum(binomialp_MLEDL_BS,2)-1<1e-8));

meansL2 = mean(binomialp_MLEL2_BS,1);
errorL2 = diff(prctile(binomialp_MLEL2_BS,[0.05 0.95],1),1)./2;
meansDL = mean(binomialp_MLEDL_BS,1);
errorDL = diff(prctile(binomialp_MLEDL_BS,[0.05 0.95],1),1)./2;

% Depricated: Extracted from the main modeling script
fh = figure;ax = gca;
x_width = 24;
y_width = 14;
hold on
errorbar(meansL2,errorL2,'Color',l2color);
errorbar(meansDL,errorDL,'Color',dlcolor);
outputDir = '/mnt/mpibr/data/Data/karimia/presentationsWriting/Talks/progressReport06082018/'
xticklabels({'L2Apical','DeepApical','Soma','Shaft','SpineDouble','SpineSingle','AIS','Glia'});
xtickangle(-45)
ylim([0 1]);
xlim([0.5 length(meansDL)+0.5]);
ylabel('PolyaFit parameter');
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'PolyaFitModel');



deepPolyaFitALphaSample = dlAlphaSample./sum(dlAlphaSample);
l2PolyaFitALphaSample = l2AlphaSample./sum(l2AlphaSample);
fh = figure;ax = gca;
x_width = 20;
y_width = 20;
hold on
plot(l2AlphaSample,'Color',l2color);
plot(dlAlphaSample,'Color',dlcolor);

xticklabels(synCount{1,1}(:,[2,3,5,6,7,4,8,9]).Properties.VariableNames);
xtickangle(-45)
ylim([0 1]);
ylabel('Mean of Polya model')
xlim([0.5 length(means)+0.5]);
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'polyaModel');