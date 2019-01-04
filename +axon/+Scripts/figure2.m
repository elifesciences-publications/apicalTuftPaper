[synCount,synRatio,synDensityInfo]=axon.extractInfoInhibitoryAxons;

%% Plotting the syn features
listOfFeatures={'pathLengthInMicron','totalSynapseNumber','synDensity'};
axon.subPlot(synDensityInfo,listOfFeatures)

outDir='/mnt/mpibr/data/Data/karimia/presentationsWriting/L1Paper/figure2_axons/axonalFeatures/';
x_width=70;
y_width=40;
set(gcf,'PaperUnits','centimeters','PaperPosition', [0 0 x_width y_width]);
saveas(gcf,fullfile(outDir,'SynFeatures.png'))

%% Plot Spec features
axon.subPlot(synRatio,{'L2Apical','DeepApical','Soma','Shaft','SpineDouble','SpineSingle','AIS','Glia'},1)
outDir='/mnt/mpibr/data/Data/karimia/presentationsWriting/L1Paper/figure2_axons/axonalFeatures/';

saveas(gcf,fullfile(outDir,'specFeatures.png'))

%% Figure 2d and 2e 
clf
colors={[0.2 0.2 0.2],[227/255 65/255 50/255],...
    [50/255 205/255 50/255],[50/255 50/255 205/255]}';
x_width=9;
y_width=7;
%Sperate Dataset-Layer 2 apical specificity 
clf
fh=figure;ax=gca;
hold on;cellfun(@axon.errorbarSpec,synRatio(1,1:4)',colors);hold off
fh = setFigureHandle(fh,'height',y_width,'width',x_width);
ax = setAxisHandle(ax);
saveas(gcf,fullfile(Figure2.Dir,'figure2d_SpearateDataset_L2ApicalSpec/',...
    addDateToName('L2SeparateSpec')),'svg')
%Sperate Dataset-Deep apical Specificity

fh=figure;ax=gca;
hold on;cellfun(@axon.errorbarSpec,synRatio(1:4,2),colors);hold off
fh = setFigureHandle(fh,'height',y_width,'width',x_width);
ax = setAxisHandle(ax);
saveas(gcf,fullfile(Figure2.Dir,'figure2e_SpearateDataset_DeepApicalSpec/',...
    addDateToName('DeepSeparateSpec')),'svg')

%% figure 2c
output=fullfile(Figure2.Dir, 'figure2c_allAxonSpecGraph/');
x_width=9;
y_width=7;
clf
fh=figure;ax=gca;
hold on;
%reweite the error bar spec so that it can handle cell array input
axon.errorbarSpec(synRatio(:),repmat([{l2color};{dlcolor}],5,1));
axon.errorbarSpec(synRatio{2,5},dlcolor);
hold off
fh = setFigureHandle(fh,'height',y_width,'width',x_width);
ax = setAxisHandle(ax);
saveas(gcf,fullfile(output,...
    addDateToName('L2SeparateSpec')),'svg')

bootStrapTestResult=use.bootStrapTest(synRatio{1,5},synRatio{2,5},false);
writetable(bootStrapTestResult,fullfile(Figure2.Dir,'figure2c_allAxonSpecGraph',...
    addDateToName('bootStrapTestResult')),'FileType','spreadsheet')



%% main text total apical ratio

synApicalRatio=sum([synRatio{5,1}{:,2:3};synRatio{5,1}{:,2:3}],2);
histogram(synApicalRatio);
fprintf('mean of the total apical targeting: %f , sem:%f \n',...
    mean(synApicalRatio)*100,bifur.sem(synApicalRatio)*100)
l2means=mean(synRatio{5,1}{:,2:3},1)*100;
l2sem=sem(synRatio{5,1}{:,2:3},1)*100;
dlmeans=mean(synRatio{5,2}{:,2:3},1)*100;
dlsem=sem(synRatio{5,2}{:,2:3},1)*100;

l2somamean=mean(synRatio{5,1}.Soma)*100;
l2somasem=sem(synRatio{5,1}.Soma)*100;
dlsomamean=mean(synRatio{5,2}.Soma)*100;
dlsomasem=sem(synRatio{5,2}.Soma)*100;
fprintf('l2 apical targeting l2: %f +- %f, dl:%f +- %f \n',...
    l2means(1),l2sem(1),l2means(2),l2sem(2))
fprintf('l2 apical soma: %f +- %f\n,dl soma: %f +- %f\n',...
    l2somamean,l2somasem,dlsomamean,dlsomasem)
fprintf('dl apical targeting l2: %f +- %f, dl:%f +- %f \n',...
    dlmeans(1),dlsem(1),dlmeans(2),dlsem(2))
