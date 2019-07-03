m=matfile(fullfile(util.dir.getAnnotation,'matfiles',...
    'axonSwitchFraction.mat'));
axonSwitchFraction=m.axonSwitchFraction;

%% Small datasets
bifurDense=apicalTuft.getObjects('bifurcation');
apType={'l2Idx','dlIdx'};correctionName={'L2','Deep'};
bifurCorrected=cell(length(apType),1);
bifurUC=cell(length(apType),1);
synInfoCorrected=cell(1,length(bifurDense));
synInfoUC=cell(1,length(bifurDense));
% get corrected and uncorrected synapse density and ratios
for apT=1:2
    for d=1:length(bifurDense)
        curTree=bifurDense{d}.(apType{apT});
        curCorrection=axonSwitchFraction.L2{correctionName{apT},:};
        density=bifurDense{d}.getSynDensityPerType(curTree,curCorrection);
        ratio=bifurDense{d}.getSynRatio(curTree,curCorrection);
        densityUC=bifurDense{d}.getSynDensityPerType(curTree);
        ratioUC=bifurDense{d}.getSynRatio(curTree);
        synInfoCorrected{d}=join(density,ratio,'Keys','treeIndex');
        synInfoUC{d}=join(densityUC,ratioUC,'Keys','treeIndex');
    end
    bifurCorrected{apT}=cat(1,synInfoCorrected{:});
    bifurUC{apT}=cat(1,synInfoUC{:});
end
bifurCorrected=cell2table(bifurCorrected','VariableNames',correctionName);
bifurUC=cell2table(bifurUC','VariableNames',correctionName);

%% Plotting
% ratios
outputFolder=fullfile(util.dir.getFig3,'correctionforAxonSwitching');
util.mkdir(outputFolder)
x_width=12;
y_width=10;
fh=figure;ax=gca;
% The densities
densities={bifurUC.L2{1}.Spine_densityUC;...
    bifurCorrected.L2{1}.Spine_density;...
    bifurUC.L2{1}.Shaft_densityUC;...
    bifurCorrected.L2{1}.Shaft_density;...
    bifurUC.Deep{1}.Spine_densityUC;...
    bifurCorrected.Deep{1}.Spine_density;...
    bifurUC.Deep{1}.Shaft_densityUC;...
    bifurCorrected.Deep{1}.Shaft_density};

% the colors
colors=repmat({[1,0,0],[1,0,0],[0,0,1],[0,0,1]},1,2);
colors=colors(:);
% plotting
util.plot.boxPlotRawOverlay(densities,1:length(densities),...
    'boxWidth',0.5,'color',colors(:));
% Additional options
set(ax,'xtick',1:8,'XTickLabel',repmat({'Uncorrected','Corrected'},1,4),...
    'XTickLabelRotation',-45,'XLim',[0.5 8.5],...
    'YTick',[0.1,1,10],'YLim',[0.01 10],'YScale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synapseDensitiesSmall.svg',...
    'off','on');
% The ratios
ratiosForPlot={bifurUC.L2{1}.Shaft_ratioUC;...
    bifurCorrected.L2{1}.Shaft_ratio;...
    bifurUC.Deep{1}.Shaft_ratioUC;...
    bifurCorrected.Deep{1}.Shaft_ratio};

colors={l2color,l2color,dlcolor,dlcolor};
% plotting
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(ratiosForPlot,1:length(ratiosForPlot),...
    'boxWidth',0.5,'color',colors(:));
% Additional options
set(ax,'xtick',1:4,'XTickLabel',repmat({'Uncorrected','Corrected'},1,2),...
    'XTickLabelRotation',-45,'XLim',[0.5 4.5],...
    'YTick',[0:0.25:1],'YLim',[0 1],'YScale','linear');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'synpseRatioSmall.svg',...
    'off','on');
%% L2 vs L3 vs L5
l235=apicalTuft.getObjects('l2vsl3vsl5');
l235{2}=l235{2}.cropoutLowRes([],3,2768);%2767 in WK
l235{2}=l235{2}.splitCC([],true);
l235Info.c=cell(3,length(l235));
l235Info.uc=cell(3,length(l235));
densityForPlot=cell(2,1);
ratioForPlot=cell(2,1);
for d=1:length(l235)
    curDForPlot=[];curRForPlot=[];
    for apT=1:3
        curTree=l235{d}.groupingVariable{1,apT}{1};
        % Use the corrections of Deep for both L3 and L5 at the level of L2
        indexL35Deep=[1,2,2];
        if d==1
            curCorrection=axonSwitchFraction.L2{indexL35Deep(apT),:};
        else
            curCorrection=axonSwitchFraction.L1{apT,:};
        end
        density=l235{d}.getSynDensityPerType(curTree,curCorrection);
        ratio=l235{d}.getSynRatio(curTree,curCorrection);
        densityUC=l235{d}.getSynDensityPerType(curTree);
        ratioUC=l235{d}.getSynRatio(curTree);
        l235Info.c{apT,d}=join(density,ratio,'Keys','treeIndex');
        l235Info.uc{apT,d}=join(densityUC,ratioUC,'Keys','treeIndex');
        curDForPlot=cat(2,curDForPlot,{densityUC.Spine,density.Spine,...
            densityUC.Shaft,density.Shaft});
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
        (fh,ax,x_width,y_width,outputFolder,'synapseDensitiesl235.svg',...
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
        (fh,ax,x_width,y_width,outputFolder,'synapseRatiol235.svg',...
        'off','on');
end