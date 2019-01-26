% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getFig1,'EG');
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
    util.addDateToFileName('ranksumTestResults'));
util.stat.ranksum.shaftRatio...
    (shaftRatio,ratios.Properties.VariableNames,fileName2Save)

%% Plot part: All Together
x_width=7.2;
y_width=6;
fh=figure;ax=gca;
util.setColors;
colors=repmat([{l2color};{dlcolor}],5,1);
% plotting
util.plot.boxPlotRawOverlay(shaftRatio(:),horizontalLocation,...
    'ylim',1,'boxWidth',1.5,'color',colors);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction.svg');
%% Plot: Separate aggregate data
aggRatio=shaftRatio(:,5);
sepRatio=shaftRatio(:,1:4);
tickSize=50;
% First plot Aggregate
x_width=6.6;
y_width=5.6;
fh=figure;ax=gca;
util.setColors;
colors=repmat([{l2color};{dlcolor}],4,1);
horizontalLocation=num2cell((1.5:2:17)');
% plotting
util.plot.boxPlotRawOverlay(sepRatio(:),horizontalLocation,...
    'xlim',[0,17],'ylim',1,'boxWidth',1.5,'color',colors,'tickSize',tickSize);
set(ax,'YTickLabel',[],'xtick',[]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction_Seperate.svg');
% Second: plot separate
x_width=6.6;
y_width=5.6;
fh=figure;ax=gca;
util.setColors;
colors=repmat([{l2color};{dlcolor}],1,1);
horizontalLocation=num2cell((1.5:2:4)');
% plotting
util.plot.boxPlotRawOverlay(aggRatio(:),horizontalLocation,...
    'xlim',[0,5],'ylim',1,'boxWidth',0.735,'color',colors,'tickSize',tickSize);
set(ax,'YTickLabel',[],'xtick',[]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction_Aggregate.svg');
%% Main text ratio
text.ratioMeans=cellfun(@mean,shaftRatio);
text.ratioSems=cellfun(@util.stat.sem,shaftRatio);
text.percentMeans=text.ratioMeans.*100;
text.percentSems=text.ratioSems.*100;
text.ratioOfRatios=text.ratioMeans(1,:)./text.ratioMeans(2,:);

disp(text)