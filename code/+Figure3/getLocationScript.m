% Get the histogram of bifurcation location of apical dendrites 

% Author: Ali Karimi<ali.karimi@brain.mpg.de>
util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig(3),'BifurcationDepth');
util.mkdir(outputDir)
% Get the bifurcation objects and then convert their coordinate to distance
% relative to pia (in voxels)
bifur=apicalTuft.getObjects('bifurcation');
bifur=apicalTuft.applyMethod2ObjectArray(bifur,'setDatasetProperties',false,false);
bifurCorrected=apicalTuft.applyMethod2ObjectArray(bifur,...
    'convert2PiaCoord',false);
bifurcationCoord=apicalTuft.applyMethod2ObjectArray...
    (bifurCorrected,'getBifurcationCoord',true);
% Plot the bifurcaitons with an overlay of the 
apicalTuft.applyMethod2ObjectArray...
(bifurCorrected,'plot',false);
dendrite.bifurLocation.scatter3(bifurcationCoord.Aggregate,[1,1,1],...
    l2color,dlcolor);

% Convert coordinate to micron from the nm of the getBifurcation coord
% output
l2dlBifurcationLocations=cellfun(@(c)c/1000,bifurcationCoord.Aggregate,...
    'UniformOutput',false);
fh = figure; ax = gca;
hold on
yyaxis left
dendrite.bifurLocation.histogram(l2dlBifurcationLocations,l2color,dlcolor);
yyaxis right
dendrite.bifurLocation.ksdensity(l2dlBifurcationLocations,l2color,dlcolor);
xticks(130:20:290);
hold off
util.plot.cosmeticsSave(fh,ax,8.6,6,outputDir,'bifurcationLocationHistogram.svg')


