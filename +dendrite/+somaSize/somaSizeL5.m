fileName=fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_somaDiameter.nml');
skel=skeleton(fileName);
numTrees=[10,3];
treeTags={'layer5ApicalDendrite_dist2soma',...
    'layer5AApicalDendrite_dist2soma'};
vol={zeros(1,numTrees(1)),zeros(1,numTrees(2))};
diameter={zeros(1,numTrees(1)),zeros(1,numTrees(2))};
for cellType=1:2
    for tr=1:numTrees(cellType)
        curTreeNames=...
        arrayfun(@(x) sprintf([treeTags{cellType},'%0.2u_%0.2u'],tr,x),1:3,...
            'UniformOutput',false);
        % Get all the diameters for a tree
        curDiameter=...
            skel.pathLength(skel.getTreeWithName(curTreeNames))./1000;
        curAvgDiameter=mean(curDiameter);
        % Volume of ellipsoid: V = 4/3 × π × a × b × c (radii)
        curVol=(4/3)*pi*prod(curDiameter./2);
        vol{cellType}(tr)=curVol;
        diameter{cellType}(tr)=curAvgDiameter;
    end
end
%% Plot box plot
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