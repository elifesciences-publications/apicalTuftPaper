%% Figure 2b: Conditional apical innervation fraction (probability) for axons with 
% one synapse on an L2 or DL apical dendrite
% Goal is to find innervation preference for the type of apical dendrites

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% set up
util.clearAll
outputDir = fullfile(util.dir.getFig(3),'B');
util.mkdir(outputDir);
horizontalLocation = num2cell(1.5:2:8)';
noiseLevel = 1.3;

%% Get the apicalSpecificity
apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');

%% Write result table to excel sheet
excelFileName = fullfile(util.dir.getExcelDir(3),'Fig3BD_4BC.xlsx');
util.table.write(synRatio, excelFileName);

%% Order is the following in spec variable:
% 1. L2 specificity of L2-seeded axons, 2. L2 specificity of DL-seeded axon
% 3. DL specificity of L2-seeded axons, 4. DL specificity of DL-seeded axon
spec{1} = synRatio.Aggregate{1}.L2Apical;
spec{2} = synRatio.Aggregate{2}.L2Apical;
spec{3} = synRatio.Aggregate{1}.DeepApical;
spec{4} = synRatio.Aggregate{2}.DeepApical;

%% The statistical testing
fileName2Save = fullfile(outputDir,'ranksumTestResults');
util.stat.ranksum.axonSpec(spec,fileName2Save);

%% Plot the boxplot for the specificity
x_width = 4.1275;
y_width = 3.26319;
fh = figure;ax = gca;
c = util.plot.getColors();
colors = [{c.l2color};{c.dlcolor};{c.l2color};{c.dlcolor}];
% plotting
util.plot.boxPlotRawOverlay(spec(:),horizontalLocation,...
    'ylim',0.7,'boxWidth',1.5,'color',colors,'tickSize',20);
yticks(0:0.1:0.7);
% Figure properties
set(ax,'XLim',[0.2 8.3],'Ylim',[0 .7])
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,...
    'Boxplot_ConditionalInnervationRatio.svg');

%% Fig. 3b, left panel: The probability matrix (average over axons)
% Get the number of synapses in each group
allCount = apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getSynCount');
% Only keep aggregate
allCount = allCount{:,5};
% Initialize
ADInnervation = ...
    array2table(zeros(2,2),'VariableNames',...
    {'L2Target','DeepTarget'},'RowNames',{'L2SeededAxons','DeepSeededAxons'});
% Get AD ratios
ADInnervation {:,1} = ...
    cellfun(@(x) nanmean(x.L2Apical./(x.L2Apical+x.DeepApical)),allCount);
ADInnervation {:,2} = ...
    cellfun(@(x) nanmean(x.DeepApical./(x.L2Apical+x.DeepApical)),allCount);
disp ('Numbers in matrix (Innervation fraction, avexraged over axons):');
disp(ADInnervation);
util.plot.probabilityMatrix(ADInnervation.Variables,[fname{3},'.svg']);