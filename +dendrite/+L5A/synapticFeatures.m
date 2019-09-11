% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Script to generate boxplots showing differences in the features  between
% L5A and L5B neurons (diameter and spine density)
util.clearAll
returnTable=true;
skel.dense=apicalTuft.getObjects('l2vsl3vsl5',[],returnTable);
skel.dim=apicalTuft.getObjects('l2vsl3vsl5Diameter',[],returnTable);

synDensity = apicalTuft.applyMethod2ObjectArray...
    (skel.dense,'getSynDensityPerType',[], false, ...
    'mapping');
dim = apicalTuft.applyMethod2ObjectArray...
    (skel.dim,'getApicalDiameter',[], false, ...
    'mapping');
% Combine L5A and LPtA data
[synDensity] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synDensity);
[dim] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(dim);
synDensity = synDensity{[3,5],:};
dim = dim{[3,5],:};

%% Get variables ready for plotting
forPlot.diameter = ...
    cellfun(@(x) x.apicalDiameter,dim,'UniformOutput',false);
forPlot.diameter = ...
    cellfun(@(x) cellfun(@mean,x),forPlot.diameter ,'UniformOutput',false);
% Spine density is equal to exc syn density without correction
forPlot.spineDensity = cellfun(@(x) x.Spine,synDensity,'UniformOutput',false);

%% Plot Diameter/spineDensity
x_width=1.9;
y_width=1.9;
boxWidths=0.708;
outputFolder=fullfile(util.dir.getFig3,'L5L5AComparison');
curColors=repmat({l5color,l5Acolor},1,2);
varNames={'diameter','spineDensity'};
region={'mainBifurcation','distalAD'};
for i=1:2
    fname=['L5L5AComparison_',varNames{i}];
    fh=figure('Name',fname);ax=gca;
    curVariable=forPlot.(varNames{i});
    util.plot.boxPlotRawOverlay(curVariable(:),1:4,...
        'boxWidth',boxWidths,'color',curColors(:),'tickSize',10);
    xlim([0.5,4.5]);
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,...
        [fname,'.svg'],'off','on');
    for j=1:2
        disp(['Variable',varNames{i}])
        disp(['Region:',region{j}])
        util.stat.ranksum(curVariable{1,j},curVariable{2,j});
    end
end

%% Testing for the text: combine distalAD and main bifurcaiton
util.stat.ranksum(cat(1,forPlot.diameter{1,:}),cat(1,forPlot.diameter{2,:}),...
    fullfile(outputFolder,'dimeterTestAll'));

util.stat.ranksum(cat(1,forPlot.spineDensity{1,:}),cat(1,forPlot.spineDensity{2,:}),...
    fullfile(outputFolder,'spineDensityCombined'));
util.copyfiles2fileServer