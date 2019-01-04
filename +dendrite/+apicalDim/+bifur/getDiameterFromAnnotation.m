config()

for dataset=1
    skel=skeleton(fullfile('/home/alik/code/alik/L1paper/NMLs/apicalDiameter/bifur/',...
        sprintf('apicalDimMeasurement_10u_sideBranches_%s_annotated.nml',...
        names(dataset))));
    l2trees=skel.getTreeWithName(info.(names(dataset)).tenUm.type{1},'first');
    l5trees=skel.getTreeWithName(info.(names(dataset)).tenUm.type{2},'first');
    [apicalDiameter,idx2keep]=apicalDim.getApicalDiameter(skel,1:skel.numTrees);
   % dist2soma=apicalDim.getDist2Soma(skel,[],idx2keep);
    zlocation=apicalDim.getRelZLocation(skel,[],idx2keep,2,false);
end

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
%saveas(fh,'+apicalDim/somaDistL5.png')
%% plot the diameter against the zlocation of apical
fh=figure;ax=gca;
apicalDim.plot(zlocation,apicalDiameter,l5trees);
%Cosmetics
xlabel('Depth relative to L4-L5 border (\mum)')
ylabel('Apical diameter (\mum)')
x_width=24;
y_width=20;
fh = setFigureHandle(fh,'height',y_width,'width',x_width);
ax = setAxisHandle(ax);
title('L5 Apical Dendrites')
%saveas(fh,'+apicalDim/zlocationL5.png')