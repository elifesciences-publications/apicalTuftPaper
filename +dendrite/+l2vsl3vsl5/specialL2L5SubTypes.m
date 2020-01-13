apTuft=apicalTuft('PPC2WeirdV1_l2vsl3vsl5');
% Weird types
wTypes={'L5ASuspect','prematureBifurcation','ObliqueL2'};

treeNames={{'layer5ApicalDendrite_mapping11',...
    'layer5ApicalDendrite_mapping12','layer5ApicalDendrite_mapping13'},...
    {'layer5ApicalDendrite_mapping05'},...
    {'layer2ApicalDendrite_mapping11','layer2ApicalDendrite_mapping12'}};

for i=1:3
    curIndices=apTuft.getTreeWithName(treeNames{i},'exact');
    weirdInhRatio.(wTypes{i})=apTuft.getSynRatio(curIndices).Shaft;
    weirdSynDensityExc.(wTypes{i})=apTuft.getSynDensityPerType(curIndices).Spine;
    weirdSynDensityInh.(wTypes{i})=apTuft.getSynDensityPerType(curIndices).Shaft;
    trIndices.(wTypes{i})=curIndices';
end
% Reorganize the ratios and densities for plotting
weirdForPlot.inhRatio={[weirdInhRatio.ObliqueL2],...
    [weirdInhRatio.L5ASuspect;weirdInhRatio.prematureBifurcation]};
weirdForPlot.excDensity={[weirdSynDensityExc.ObliqueL2],...
    [weirdSynDensityExc.L5ASuspect;...
    weirdSynDensityExc.prematureBifurcation]};
weirdForPlot.inhDensity={[weirdSynDensityInh.ObliqueL2],...
    [weirdSynDensityInh.L5ASuspect;...
    weirdSynDensityInh.prematureBifurcation]};
% Get the original values minus the wierd types
inhRatio=cell(3,1);synDensityExc=cell(3,1);synDensityInh=cell(3,1);
for i=1:3
    curTrees=setdiff(apTuft.groupingVariable{1,i}{1},...
        struct2array(trIndices));
    inhRatio{i}=apTuft.getSynRatio(curTrees).Shaft;
    synDensityExc{i}=apTuft.getSynDensityPerType(curTrees).Spine;
    synDensityInh{i}=apTuft.getSynDensityPerType(curTrees).Shaft;
end


%% Plotting inhibitoy ratio
outputFolder=fullfile(util.dir.getFig(3),'weirdCellType');
util.mkdir(outputFolder);
wColor=[0,0,0];
wMarker='*';
util.setColors
x_width=5.3*4;
y_width=3.5*4;
colors={l2color,l3color,l5color};

% inhibitory Ratio
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(inhRatio,1:3,'ylim',1,'boxWidth',0.5,...
'color',colors,'boxplot',false);
util.plot.boxPlotRawOverlay(weirdForPlot.inhRatio,[1,3],'ylim',1,'boxWidth',0.5,...
'color',{wColor,wColor},'boxplot',false,'marker',wMarker);
xticks([1:3]);
xticklabels({'L2','L3','L5'});
yticks(0:0.2:1)
ylabel('Fraction of inhibitory synapses')
xlabel('Pyramidal cell type')
xlim([0.5, 3.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'ShaftFraction.png');
%% Plotting synapse density
util.mkdir(outputFolder)
util.setColors
x_width=10;
y_width=15;
colors=repmat({exccolor;inhcolor},1,3);
colorsWierd=repmat({wColor},2,2);
allDensitites=[synDensityExc';synDensityInh'];
allDensititesWeird=[weirdForPlot.excDensity;weirdForPlot.inhDensity];
% Density plot
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(allDensitites(:),1:6,'ylim',10,'boxWidth',0.5,...
'color',colors(:),'boxplot',false);
util.plot.boxPlotRawOverlay(allDensititesWeird(:),[1,2,5,6]','ylim',6,'boxWidth',0.5,...
'color',colorsWierd(:),'boxplot',false,'marker',wMarker);
set(ax,'yscale','linear');
xticks(1.5:2:5.5)
xticklabels({'L2','L3','L5'});
ylabel({'Synapse density', '(per \mum shaft path length)'});
xlabel('Pyramidal cell type')
xlim([0.5,6.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensities.png','off','on');