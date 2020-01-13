% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Generates the soma size and volume figure
fileName=fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_somaDiameter.nml');
skel=skeleton(fileName);
numTrees=[12,6];
treeTags={'layer5ApicalDendrite_dist2soma',...
    'layer5AApicalDendrite_dist2soma'};
% Get the volume and diameter from measurements of format:
% treename_01,02,03: the three diameters
[vol,diameter]=dendrite.L5A.getSomaSize(skel,treeTags,numTrees);

%% Plot box plot of comparison between soma sizes of L5B and L5A
x_width=2;
y_width=1.9;
outputFolder=fullfile(util.dir.getFig(5),...
    'somaSizeL5vsL5A');util.mkdir(outputFolder);
fname='somaVolume_L5vsL5A';
fh=figure('Name',fname);ax=gca;
util.setColors;
curColors={l5color,l5Acolor};
util.plot.boxPlotRawOverlay(vol,1:2,...
    'boxWidth',0.4655,'color',curColors);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on')

fname='somaAverageDiameter_L5vsL5A';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(diameter,1:2,...
    'boxWidth',0.4655,'color',curColors);
ylim([10,20])
util.stat.ranksum(diameter{1},diameter{2},...
    fullfile(outputFolder,'SomaDiameter'));
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on');
%% Plot the histogram for the soma size
fname='histogram_L5vsL5A';
fh=figure('Name',fname);ax=gca;
hold on
for i=1:length(diameter)
    histogram(diameter{i},'BinEdges',0:1:20,'DisplayStyle','stairs','EdgeColor', curColors{i})
end
xlim([0,20.5]); ylim([0,3]);
util.plot.cosmeticsSave...
    (fh,ax,2.3,2,outputFolder,...
    [fname,'.svg'],'off','on');
%% correlation between soma size and shaft ratio
% Get results
results = dendrite.synSwitch.getCorrected.getAllRatioAndDensityResult;
%% Plot
resultsL5 = results.l235.mainBifurcation([3,5])';
% Get corrected shaft ratio for L5tt and uncorrected shaft ratio for
% first row is uncorrected (L5tt) vs second row of each results is
% corrected (L5st)
curVars={'Shaft_Ratio','Shaft_Density','Spine_Density'};
indexCorrection = [1,2];
xWidth=2;yWidth=2;
for i=1:3
    fname=['CorrelationL5_SomaSize_',curVars{i}];
    fh=figure('Name',fname);ax=gca;
    fullNameForText=fullfile(outputFolder,[fname,'.txt']);
    curMeasure= cell(1,2);
    % Concatenate soma diameter with the shaft,spine density/fraction
    for l5=1:2
        curMeasure{l5} = [diameter{l5}', ...
            resultsL5{l5}.(curVars{i})(:,indexCorrection(l5))];
    end
    % Plot with scatter with linear fit
    util.plot.correlation(curMeasure,{l5color,l5Acolor},...
        [],10,fullNameForText);
    util.plot.addLinearFit(curMeasure,[],true,...
        fullNameForText);
    util.plot.cosmeticsSave...
        (fh,ax,xWidth,yWidth,outputFolder,...
        [fname,'.svg'],'on','on');
end
%% Save the soma depth information
matfolder = fullfile(util.dir.getAnnotation,'matfiles',...
    'L5stL5ttFeatures');
util.mkdir (matfolder)
save(fullfile(matfolder,'somaDiameter.mat'),'diameter');
