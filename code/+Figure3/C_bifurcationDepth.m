%% Figure 3C, left panel:
% Histogram and kernel density of the depth distribution of apical dendrites 

% Author: Ali Karimi<ali.karimi@brain.mpg.de>
util.clearAll;
outputDir = fullfile(util.dir.getFig(3),'C');
util.mkdir(outputDir)
c = util.plot.getColors();

%% Get the bifurcation objects and then convert their coordinate to distance
% relative to pia (in voxels)
bifur = apicalTuft.getObjects('bifurcation');
bifurCorrected = apicalTuft.applyMethod2ObjectArray(bifur,...
    'convert2PiaCoord',false,false);
bifurcationCoord = apicalTuft.applyMethod2ObjectArray...
    (bifurCorrected,'getBifurcationCoord',true,[],[],true,true);
aggCoords = cellfun(@(x) x.bifurcationCoord, bifurcationCoord.Aggregate,...
    'UniformOutput',false);

%% Write to table
excelFileName = fullfile(util.dir.getExcelDir(3),'Fig3C_bifurcationDepth.xlsx');
util.table.write(bifurcationCoord, excelFileName);

%% Plot the skeleton bifurcations with spheres representing the bifurcation
% coordinate
debug = false;
if debug
    apicalTuft.applyMethod2ObjectArray...
        (bifurCorrected,'plot',false); %#ok<*UNRCH>
    dendrite.bifurLocation.scatter3(aggCoords,[1,1,1],...
    c.l2color, c.dlcolor);
end

%% Convert coordinate to micron from the nm of the getBifurcation coord
% output

fh = figure; ax = gca;
% Match the figure size to that of the other panel in Fig. 3c
x_width = 1.98729;
y_width = 2.89051;
coordOfBifurcationsInMicron = cellfun(@(c) c/1000, aggCoords, ... 
    'UniformOutput',false);
hold on
yyaxis left
dendrite.bifurLocation.histogram(coordOfBifurcationsInMicron, ... 
    c.l2color,c.dlcolor);
% Rotate labels for easier use
ytickangle(90);
yyaxis right
dendrite.bifurLocation.ksdensity(coordOfBifurcationsInMicron, ... 
    c.l2color,c.dlcolor);
% tick locations
xticks(110:20:310);
% rotate lavels
xtickangle(90);ytickangle(90);
hold off
% Match to the limits of the axonal path density
xlim([105,315]);
util.plot.cosmeticsSave(fh,ax,y_width,x_width,outputDir,...
    'Fig.3C_bifurcationDist.svg');
