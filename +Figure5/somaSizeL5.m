% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Generates the soma size and volume figure
fileName=fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_somaDiameter.nml');
skel=skeleton(fileName);
numTrees=[10,3];
treeTags={'layer5ApicalDendrite_dist2soma',...
    'layer5AApicalDendrite_dist2soma'};
% Get the volume and diameter from measurements of format:
% treename_01,02,03: the three diameters
[vol,diameter]=dendrite.L5A.getSomaSize(skel,treeTags,numTrees);

%% Plot box plot of comparison between soma sizes of L5B and L5A
x_width=2;
y_width=1.9;
outputFolder=fullfile(util.dir.getFig3,...
    'somaSizeL5vsL5A');
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
