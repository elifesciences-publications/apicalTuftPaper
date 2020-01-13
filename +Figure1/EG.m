% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getFig(1),'EG');
util.mkdir(outputFolder);
%% Get synapse ratios
apTuft=apicalTuft.getObjects('bifurcation');
ratios=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
shaftRatio=cellfun(@(x) x.Shaft,ratios.Variables,'UniformOutput',false);
horizontalLocation=num2cell((1.5:2:20)');
noiseLevel=1.3;
func=@(array,position)...
    util.plot.addHorizontalNoise(array,position,noiseLevel);
shaftRatiowithNoisyX=cellfun(func,shaftRatio(:),horizontalLocation,...
    'UniformOutput',false);
%% Write result table to excel sheet
matFileName=fullfile(outputFolder,'Figure1_InhibitoryRatios.mat');
save(util.addDateToFileName( matFileName),'ratios');
%% The statistical testing
% ratio aggregate comparison
util.stat.ranksum(shaftRatio{1,5},shaftRatio{2,5})
fileName2Save=fullfile(outputFolder,...
    'ranksumTestResults.txt');
util.stat.ranksum.shaftRatio...
    (shaftRatio,ratios.Properties.VariableNames,fileName2Save)

util.stat.ranksum...
    (shaftRatio{1,5},shaftRatio{2,5},fileName2Save)
%% Plot: Separate aggregate data
aggRatio=shaftRatio(:,5);
sepRatio=shaftRatio(:,1:4);
tickSize=10;
% First plot Aggregate
x_width=3.1;
y_width=2.8;
fh=figure;ax=gca;
util.setColors;
colors=repmat([{l2color};{dlcolor}],4,1);
horizontalLocation=num2cell((1.5:2:17)');
% plotting
util.plot.boxPlotRawOverlay(sepRatio(:),horizontalLocation,...
    'xlim',[0,17],'ylim',1,'boxWidth',1.5,'color',colors,'tickSize',tickSize);
set(ax,'YTickLabel',[],'YTick',0:0.2:1);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction_Seperate.svg');
% Second: plot separate

fh=figure;ax=gca;
util.setColors;
colors=repmat([{l2color};{dlcolor}],1,1);
horizontalLocation=num2cell([1.275,3.825]');
% plotting
util.plot.boxPlotRawOverlay(aggRatio(:),horizontalLocation,...
    'ylim',1,'boxWidth',0.75,'color',colors,'tickSize',tickSize);
set(ax,'YTickLabel',[],'YTick',0:0.2:1,'XLim',[0.2 5.3]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction_Aggregate.svg');
%% Main text ratio
text.ratioMeans=cellfun(@mean,shaftRatio);
text.ratioSems=cellfun(@util.stat.sem,shaftRatio);
text.percentMeans=text.ratioMeans.*100;
text.percentSems=text.ratioSems.*100;
text.ratioOfRatios=text.ratioMeans(1,:)./text.ratioMeans(2,:);

disp(text)