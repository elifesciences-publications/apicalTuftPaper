%% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getFig3,'correctionforAxonSwitching');
util.mkdir(outputFolder)
m=matfile(fullfile(util.dir.getAnnotation,'matfiles',...
    'axonSwitchFraction.mat'));
axonSwitchFraction=m.axonSwitchFraction;

%% Get the skeletons for dense reconstruction
skel.bifur=apicalTuft.getObjects('bifurcation');
skel.l235=apicalTuft.getObjects('l2vsl3vsl5');

%% Get the uncorrected synapse density and ratios
synDensity.uc.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur,'getSynDensityPerType',[], false);
synDensity.uc.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235,'getSynDensityPerType',[], false, ...
    'mapping');
synRatio.uc.bifur=apicalTuft.applyMethod2ObjectArray...
    (skel.bifur,'getSynRatio',[], false);
synRatio.uc.l235=apicalTuft.applyMethod2ObjectArray...
    (skel.l235,'getSynRatio',[], false, ...
    'mapping');
synDensity.uc=dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synDensity.uc);
synRatio.uc=dendrite.l2vsl3vsl5.combineL5AwithLPtATable(synRatio.uc);

%% Datasets within L2: small datasets containing the main bifurcation 
% annotations in L2
[results]=...
    dendrite.synSwitch.getCorrected.L2Datasets(skel,synRatio,synDensity);
%% Plotting
% ratios
x_width=12;
y_width=10;
fh=figure;ax=gca;
% The densities
curResults=results.bifur.Aggregate;
util.plot.correlation({curResults{1}.Shaft_Ratio,...
    curResults{2}.Shaft_Ratio},{l2color,dlcolor});
limits=[0,1];
set(ax,'XLim',limits,'YLim',limits);
plot([limits(1),limits(2)],[limits(1),limits(2)],'Color','k');
daspect([1,1,1])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'L2Datasets_synRatios.svg',...
    'on','on');
fh=figure;ax=gca;
util.plot.correlation({curResults{1}.Shaft_Density,...
    curResults{2}.Shaft_Density,curResults{1}.Spine_Density,...
    curResults{2}.Spine_Density},{l2color,dlcolor,l2color,dlcolor},...
    {'.','.','x','x'});
limits=[0,5];
set(ax,'XLim',limits,'YLim',limits);
plot([limits(1),limits(2)],[limits(1),limits(2)],'Color','k');
daspect([1,1,1]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'L2Datasets_synDensities.svg',...
    'on','on');
%% L2 vs L3 vs L5
skel.l235{2}=skel.l235{2}.cropoutLowRes([],3,2768);%2767 in WK
skel.l235{2}=skel.l235{2}.splitCC([],true);
skel.l235Info.c=cell(3,length(skel.l235));
skel.l235Info.uc=cell(3,length(skel.l235));
densityForPlot=cell(2,1);
ratioForPlot=cell(2,1);
for d=1:length(skel.l235)
    curDForPlot=[];curRForPlot=[];
    for apT=1:3
        curTreeIdx=skel.l235{d}.groupingVariable{1,apT}{1};
        % Use the corrections of Deep for both L3 and L5 at the level of L2
        indexL35Deep=[1,2,2];
        if d==1
            curCorrection=axonSwitchFraction.L2{indexL35Deep(apT),:};
        else
            curCorrection=axonSwitchFraction.L1{apT,:};
        end
        curSynDensity=skel.l235{d}.getSynDensityPerType(curTreeIdx,curCorrection);
        ratio=skel.l235{d}.getSynRatio(curTreeIdx,curCorrection);
        densityUC=skel.l235{d}.getSynDensityPerType(curTreeIdx);
        ratioUC=skel.l235{d}.getSynRatio(curTreeIdx);
        skel.l235Info.c{apT,d}=join(curSynDensity,ratio,'Keys','treeIndex');
        skel.l235Info.uc{apT,d}=join(densityUC,ratioUC,'Keys','treeIndex');
        curDForPlot=cat(2,curDForPlot,{densityUC.Spine,curSynDensity.Spine,...
            densityUC.Shaft,curSynDensity.Shaft});
        curRForPlot=cat(2,curRForPlot,{ratioUC.Shaft,ratio.Shaft});
    end
    densityForPlot{d}=curDForPlot;
    ratioForPlot{d}=curRForPlot;
end

%% Plotting
% ratios
outputFolder=fullfile(util.dir.getFig3,'correctionforAxonSwitching');
util.mkdir(outputFolder)
x_width=12;
y_width=10;
% the colors
colors=repmat({[1,0,0],[1,0,0],[0,0,1],[0,0,1]},1,3);
colors=colors(:);
for i=1:2
    fh=figure;ax=gca;
    % plotting
    util.plot.boxPlotRawOverlay(densityForPlot{i},1:length(densityForPlot{i}),...
        'boxWidth',0.5,'color',colors(:));
    % Additional options
    set(ax,'xtick',1:12,'XTickLabel',repmat({'Uncorrected','Corrected'},1,4),...
        'XTickLabelRotation',-45,'XLim',[0.5 12.5],...
        'YTick',[0.04,0.4,4],'YLim',[0.025 8],'YScale','log');
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,'synapseDensitiesskel.l235.svg',...
        'off','on');
end
colors={l2color,l2color,...
    l3color,l3color,l5color,l5color};
for i=1:2
    fh=figure;ax=gca;
    % plotting
    util.plot.boxPlotRawOverlay(ratioForPlot{i},1:length(ratioForPlot{i}),...
        'boxWidth',0.5,'color',colors(:));
    % Additional options
    set(ax,'xtick',1:6,'XTickLabel',repmat({'Uncorrected','Corrected'},1,3),...
        'XTickLabelRotation',-45,'XLim',[0.5 6.5],...
        'YTick',[0:0.25:1],'YLim',[0 1]);
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,'synapseRatioskel.l235.svg',...
        'off','on');
end