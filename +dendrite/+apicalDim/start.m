nmlName='D:\code\alik\L1paper\NMLs\apicalDiameter\Measuring_L5andL3_ApicalDiameter_Taper.nml';

skel=skeleton(nmlName);

treeIdx=skel.getTreeWithName('L5','first');
[apicalDiameter,idx2keep]=apicalDim.getApicalDiameter(skel,treeIdx);
dist2soma=apicalDim.getDist2Soma(skel,treeIdx,idx2keep);
zlocation=apicalDim.getRelZLocation(skel,treeIdx,idx2keep);
%% Plot the diameter against the soma
fh=figure;ax=gca;
apicalDim.plot(dist2soma,apicalDiameter,treeIdx);
%Cosmetics
xlabel('Distance to soma (\mum)')
ylabel('Apical diameter (\mum)')
x_width=24;
y_width=20;
fh = setFigureHandle(fh,'height',y_width,'width',x_width);
ax = setAxisHandle(ax);
title('L5 Apical Dendrites')
saveas(fh,'+apicalDim/somaDistL5.png')
%% plot the diameter against the zlocation of apical
fh=figure;ax=gca;
apicalDim.plot(zlocation,apicalDiameter,treeIdx);
%Cosmetics
xlabel('Depth relative to L4-L5 border (\mum)')
ylabel('Apical diameter (\mum)')
x_width=24;
y_width=20;
fh = setFigureHandle(fh,'height',y_width,'width',x_width);
ax = setAxisHandle(ax);
title('L5 Apical Dendrites')
saveas(fh,'+apicalDim/zlocationL5.png')

