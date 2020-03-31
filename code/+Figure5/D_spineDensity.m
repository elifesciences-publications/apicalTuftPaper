%% Fig. 5D: Comaprison of spine density between L5tt and L5st neurons
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

util.clearAll
c = util.plot.getColors();
returnTable = true;
%% Get skeleton and spine density (equivalent to the "Spine"/Excitatory
% synapse group)
skel.dense = apicalTuft.getObjects('l2vsl3vsl5',[],returnTable);
synDensity = apicalTuft.applyMethod2ObjectArray...
    (skel.dense,'getSynDensityPerType',[], false, ...
    'mapping');
% Combine L5st results in LptA and PPC-2 datasets
[synDensity] = dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synDensity);
% Keep only L5 data
synDensity = synDensity{[3,5],:};

%% Get spine density ready for plotting
% Spine density is equal to excitatory synapse density 
spineDensitySep = cellfun(@(x) x.Spine,synDensity,'UniformOutput',false);
spineDensityTableSep = cellfun(@(x) x(:,[1,3]),synDensity,...
    'UniformOutput',false);
% Merge the results from main bifurcation and distal AD
spineDensityForPlot = cell(1,2);
spineDensityTable = cell(1,2);
for i = 1:2
    spineDensityForPlot{i} = cat(1, spineDensitySep{i,:});
    spineDensityTable{i} = cat(1, spineDensityTableSep{i,:});
end

%% Plot spineDensity
x_width = 2;
y_width = 3.8;
boxWidths = 0.4655;
outputFolder = fullfile(util.dir.getFig(5),...
    'D');util.mkdir(outputFolder)
curColors = {c.l5color,c.l5Acolor};
region = {'mainBifurcation','distalAD'};

fname = 'L5SubtypeComparison_spineDensity';
fh = figure('Name',fname);ax = gca;

util.plot.boxPlotRawOverlay(spineDensityForPlot(:),1:2,...
    'boxWidth',boxWidths,'color',curColors(:),'tickSize',10);
xlim([0.5,2.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on');

%% Ranksum test comparison of L5tt and L5st synapse densities
util.stat.ranksum(spineDensityForPlot{1},spineDensityForPlot{2},...
    fullfile(outputFolder,'spineDensityCombined'));

%% Save the spine density information
excelFileName = fullfile(util.dir.getExcelDir(5),'Fig5D.xlsx');
spineDensityTableOfTable = cell2table(spineDensityTable,...
    'VariableNames',{'L5tt', 'L5st'},'RowNames',{'spineDensity'});
util.table.write(spineDensityTableOfTable, excelFileName);
