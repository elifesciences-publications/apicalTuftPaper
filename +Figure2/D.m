%% figure 2d
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% set up
util.clearAll
outputDir=fullfile(util.dir.getFig2,'D');
util.mkdir(outputDir);
horizontalLocation=num2cell([1.5:2:8])';
noiseLevel=1.3;
% Get the apicalSpecificity
apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
spec{1}=synRatio{1,5}{1}.L2Apical;
spec{2}=synRatio{2,5}{1}.L2Apical;
spec{3}=synRatio{1,5}{1}.DeepApical;
spec{4}=synRatio{2,5}{1}.DeepApical;
%% The statistical testing
fileName2Save=fullfile(outputDir,util.addDateToFileName('ranksumTestResults'));
util.stat.ranksum.axonSpec(spec,fileName2Save);

%% Plot part
x_width=8;
y_width=6;
fh=figure;ax=gca;
colors=[{l2color};{dlcolor};{l2color};{dlcolor}];
% plotting
util.plot.boxPlotRawOverlay(spec(:),horizontalLocation,...
    'ylim',0.7,'boxWidth',1.5,'color',colors);
yticks(0:0.1:0.7)
% Figure properties
set(ax,'XLim',[0.2 8.3],'Ylim',[0 .7])
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'apicalSpecificity.svg');