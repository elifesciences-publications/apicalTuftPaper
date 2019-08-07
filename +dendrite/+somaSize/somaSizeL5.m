fileName=fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_somaDiameter.nml');
skel=skeleton(fileName);
numTrees=[10,3];
treeTags={'layer5ApicalDendrite_dist2soma',...
    'layer5AApicalDendrite_dist2soma'};
% Get the volume and diameter from measurements of format:
% treename_01,02,03: the three diameters
[vol,diameter]=dendrite.somaSize.getSomaSize(skel,treeTags,numTrees);

%% Plot box plot of comparison between soma sizes of L5B and L5A
x_width=8;
y_width=10;
outputFolder=fullfile(util.dir.getFig3,...
    'somaSizeL5vsL5A');
fname='somaVolume_L5vsL5A';
fh=figure('Name',fname);ax=gca;
util.setColors;
curColors={l5color,l5Acolor};
util.plot.boxPlotRawOverlay(vol,1:2,...
    'boxWidth',0.5,'color',curColors);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'on','on')

fname='somaAverageDiameter_L5vsL5A';
fh=figure('Name',fname);ax=gca;
util.plot.boxPlotRawOverlay(diameter,1:2,...
    'boxWidth',0.5,'color',curColors);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'on','on')