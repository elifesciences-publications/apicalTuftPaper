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
forPlotSep.diameter = ...
    cellfun(@(x) x.apicalDiameter,dim,'UniformOutput',false);
forPlotSep.diameter = ...
    cellfun(@(x) cellfun(@mean,x),forPlotSep.diameter ,'UniformOutput',false);
% Spine density is equal to exc syn density without correction
forPlotSep.spineDensity = cellfun(@(x) x.Spine,synDensity,'UniformOutput',false);
% Merge distalAD with the bifurcation area results
for i=1:2
    forPlot.spineDensity{i}=cat(1, forPlotSep.spineDensity{i,:});
    forPlot.diameter{i}=cat(1, forPlotSep.diameter{i,:});
end
%% Plot Diameter/spineDensity
x_width=2;
y_width=1.9;
boxWidths=0.4655;
outputFolder=fullfile(util.dir.getFig5,...
    'L5L5AComparison');util.mkdir(outputFolder)
curColors={l5color,l5Acolor};
varNames={'diameter','spineDensity'};
region={'mainBifurcation','distalAD'};
for i=1:2
    fname=['L5L5AComparison_',varNames{i}];
    fh=figure('Name',fname);ax=gca;
    curVariable=forPlot.(varNames{i});
    util.plot.boxPlotRawOverlay(curVariable(:),1:2,...
        'boxWidth',boxWidths,'color',curColors(:),'tickSize',10);
    xlim([0.5,2.5]);
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,...
        [fname,'.svg'],'off','on');

end

%% Testing for the text: combine distalAD and main bifurcaiton
util.stat.ranksum(cat(1,forPlot.diameter{1}),cat(1,forPlot.diameter{2}),...
    fullfile(outputFolder,'dimeterTestAll'));

util.stat.ranksum(cat(1,forPlot.spineDensity{1}),cat(1,forPlot.spineDensity{2}),...
    fullfile(outputFolder,'spineDensityCombined'));
util.copyfiles2fileServer

%% Save the soma depth information
diameterBifurcation = forPlotSep.diameter(:,1)';
spineDensityBifurcation = forPlotSep.spineDensity(:,1)';

matfolder = fullfile(util.dir.getAnnotation,'matfiles',...
    'L5stL5ttFeatures');
util.mkdir (matfolder)
save(fullfile(matfolder,'diameterAndSpineDensityAtMainBifurcation.mat'),...
    'diameterBifurcation','spineDensityBifurcation');