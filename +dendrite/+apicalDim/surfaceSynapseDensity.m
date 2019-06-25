% Get the diameter
bifurDense=apicalTuft.getObjects('bifurcation');
bifurDim=apicalTuft.getObjects('bifurcationDiameter');
l235Dense=apicalTuft.getObjects('l2vsl3vsl5');
l235Dim=apicalTuft.getObjects('l2vsl3vsl5Diameter');
% LPtA dataset: crop out the lowres part
l235Dim{2}=l235Dim{2}.cropoutLowRes([],3,2768);%2767 in WK
l235Dim{2}=l235Dim{2}.splitCC([],true);
l235Dense{2}=l235Dense{2}.cropoutLowRes([],3,2768);%2767 in WK
l235Dense{2}=l235Dense{2}.splitCC([],true);
%% First step get all the synapse counts from dense annotations
synCount.bifur=apicalTuft.applyMethod2ObjectArray...
    (bifurDense,'getSynCount',[], false);
synCount.l235=apicalTuft.applyMethod2ObjectArray...
    (l235Dense,'getSynCount',[], false, ...
    'mapping');

%% Second: get the pathlength from diameter measurements
pL.bifur=apicalTuft.applyMethod2ObjectArray...
    (bifurDim,'pathLength',[], false);
pL.l235=apicalTuft.applyMethod2ObjectArray...
    (l235Dim,'pathLength',[], false, ...
    'mapping');
%% Get the diameter annotations
diam.bifur=apicalTuft.applyMethod2ObjectArray...
    (bifurDim,'getApicalDiameter',[], false);
diam.l235=apicalTuft.applyMethod2ObjectArray...
    (l235Dim,'getApicalDiameter',[], false, ...
    'mapping');

anotType={'bifur','l235'};
for i=1:2
    % Use thisT for the sizes and initializing the result
    thisT=diam.(anotType{i});
    results.(anotType{i})=cell2table(cell(size(thisT)),...
        'VariableNames',thisT.Properties.VariableNames,'RowNames',...
        thisT.Properties.RowNames);
    for d=1:width(thisT)
        for trType=1:height(thisT)
            % Get the current variables
            curDiam=diam.(anotType{i}){trType,d}{1};
            curDiam.apicalDiameter=...
                cellfun(@mean,curDiam.apicalDiameter);
            curpL=pL.(anotType{i}){trType,d}{1};
            curSynCount=synCount.(anotType{i}){trType,d}{1};
            % Get the table of all the densities for the current
            % annotations
            curTable=join(join(curDiam,curpL),curSynCount);
            % Lateral cylinder area= pi*avg diameter*Height
            curTable.area=pi*(curTable.apicalDiameter.*...
                curTable.pathLengthInMicron);
            curTable.inhDensity=curTable.Shaft./ ...
                curTable.pathLengthInMicron;
            curTable.excDensity=curTable.Spine./ ...
                curTable.pathLengthInMicron;
            curTable.inhSurfDensity=curTable.Shaft./curTable.area;
            curTable.excSurfDensity=curTable.Spine./curTable.area;
            % The combined structure of tables
            results.(anotType{i}){trType,d}{1}=curTable;
        end
    end
end
%% Plot the diameter of different cell types
% Smaller datasets: S1, V2, PPC and ACC
x_width=8.5;
y_width=10;
outputFolder=fullfile(util.dir.getFig3,...
    'synapseDensityPerUnitSurface');
diameters=cellfun(@(x) x.apicalDiameter,results.bifur.Variables,...
    'UniformOutput',false);
combineDiameterSmall={cat(1,diameters{1,:}),cat(1,diameters{2,:})};
util.mkdir(outputFolder)
util.setColors

colors={l2color;dlcolor};
% Density plot
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(combineDiameterSmall(:),1:2,'ylim',3.5,...
    'boxWidth',0.5,...
    'color',colors(:));
xticklabels([]);
ylabel([]);
xlim([0.5,2.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'apicalDiameterSmall.svg','off','on');
pvalDiameterSmall=...
    ranksum(combineDiameterSmall{1},combineDiameterSmall{2});
disp (['pvalue of small diameter ranksum test=',num2str(pvalDiameterSmall)])
%% PPC2 dataset diameter
diameters=cellfun(@(x) x.apicalDiameter,results.l235.PPC2,...
    'UniformOutput',false);
util.mkdir(outputFolder)
x_width=12;
y_width=10;
colors={l2color;l3color;l5color};
% Density plot
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(diameters(:),1:3,'ylim',3.5,...
    'boxWidth',0.5,...
    'color',colors(:));
xticklabels([]);
ylabel([]);
xlim([0.5,3.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'apicalDiameterPPC2.svg','off','on');
pvalDiameterPPC2=...
    kruskalwallis([diameters{1},diameters{2},diameters{3}]);
disp (['pvalue of small diameter kruskallWallis test=',...
    num2str(pvalDiameterPPC2)])

%% LPtA diameters
diameters=cellfun(@(x) x.apicalDiameter,results.l235.LPtA,...
    'UniformOutput',false);
util.mkdir(outputFolder)
util.setColors

colors={l2color;l3color;l5color};
% Density plot
fh=figure;ax=gca;
util.plot.boxPlotRawOverlay(diameters(:),1:3,'ylim',3.5,...
    'boxWidth',0.5,...
    'color',colors(:));
xticklabels([]);
ylabel([]);
xlim([0.5,3.5])
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'apicalDiameterLPtA.svg','off','on');
pvalDiameterLPtA=...
    kruskalwallis([diameters{1};diameters{2};diameters{3}],...
    [repmat({'L2'},size(diameters{1}));...
    repmat({'L3'},size(diameters{2}));...
    repmat({'L5'},size(diameters{3}))]);
disp (['pvalue of small diameter kruskallWallis test=',...
    num2str(pvalDiameterLPtA)])
%% Plot the surface area synapse densities
% Smaller datasets: S1, V2, PPC and ACC
x_width=8.5;
y_width=10;
outputFolder=fullfile(util.dir.getFig3,...
    'synapseDensityPerUnitSurface');
inhSurfDensity=cellfun(@(x) x.inhSurfDensity,results.bifur.Variables,...
    'UniformOutput',false);
excSurfDensity=cellfun(@(x) x.excSurfDensity,results.bifur.Variables,...
    'UniformOutput',false);
combineDensitySmall={cat(1,excSurfDensity{1,:}),...
    cat(1,excSurfDensity{2,:});cat(1,inhSurfDensity{1,:}),...
    cat(1,inhSurfDensity{2,:})};
util.mkdir(outputFolder)
colors=repmat({exccolor;inhcolor},1,2);
% Density plot
fh=figure;ax=gca;
xlength=4;
util.plot.boxPlotRawOverlay(combineDensitySmall(:),1:xlength,'ylim',1,...
    'boxWidth',0.5,...
    'color',colors(:));
xticklabels([]);
ylabel([]);
set(ax,'yscale','log');
xlim([0.5,xlength+0.5]);
ylim([0.004,2]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'densitySurfSmall.svg','off','on');
pvalexcSurfSmall=...
    ranksum(combineDensitySmall{1,1},combineDensitySmall{1,2});
disp (['pvalue of excitatory surface synapseDensity ranksum test=',...
    num2str(pvalexcSurfSmall)])

pvalinhSurfSmall=...
    ranksum(combineDensitySmall{2,1},combineDensitySmall{2,2});
disp (['pvalue of inhibitory surface synapseDensity ranksum test=',...
    num2str(pvalDiameterSmall)])
%% PPC2 dataset densities
x_width=12;
y_width=10;
inhSurfDensity=cellfun(@(x) x.inhSurfDensity,results.l235.PPC2,...
    'UniformOutput',false);
excSurfDensity=cellfun(@(x) x.excSurfDensity,results.l235.PPC2,...
    'UniformOutput',false);
util.mkdir(outputFolder)
densities=[excSurfDensity';inhSurfDensity'];
colors=repmat({exccolor;inhcolor},1,3);
% Density plot
fh=figure;ax=gca;
xlength=6;
util.plot.boxPlotRawOverlay(densities(:),1:xlength,'ylim',2,...
    'boxWidth',0.5,...
    'color',colors(:));
xticklabels([]);
ylabel([]);
xlim([0.5,xlength+.5]);
ylim([0.004,2]);

set(ax,'yscale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'densitySurfPPC2.svg','off','on');
pvalExcDensityPPC2=...
    kruskalwallis([densities{1,1},densities{1,2},densities{1,3}]);
disp (['pvalue of excitatory synapse density ppc2 kruskallWallis test=',...
    num2str(pvalDiameterPPC2)]);

pvalInhDensityPPC2=...
    kruskalwallis([densities{2,1},densities{2,2},densities{2,3}]);
disp (['pvalue of inhibitory synapse density ppc2 kruskallWallis test=',...
    num2str(pvalDiameterPPC2)])

%% LPtA densities
inhSurfDensity=cellfun(@(x) x.inhSurfDensity,results.l235.LPtA,...
    'UniformOutput',false);
excSurfDensity=cellfun(@(x) x.excSurfDensity,results.l235.LPtA,...
    'UniformOutput',false);
densities=[excSurfDensity';inhSurfDensity'];

util.mkdir(outputFolder)
util.setColors

colors=repmat({exccolor;inhcolor},1,3);
% Density plot
fh=figure;ax=gca;
xlength=6;
util.plot.boxPlotRawOverlay(densities(:),1:xlength,'ylim',2,...
    'boxWidth',0.5,...
    'color',colors(:));
xticklabels([]);
ylabel([]);
xlim([0.5,xlength+.5]);
ylim([0.004,2]);

set(ax,'yscale','log');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,'densitySurfLPtA.svg','off','on');
pvalExcDensityLPtA=...
    kruskalwallis([densities{1,1};densities{1,2};densities{1,3}],...
    [repmat({'L2'},size(densities{1,1}));...
    repmat({'L3'},size(densities{1,2}));...
    repmat({'L5'},size(densities{1,3}))]);
disp (['pvalue of exc syn density LPtA kruskallWallis test=',...
    num2str(pvalExcDensityLPtA)])

pvalInhDensityLPtA=...
    kruskalwallis([densities{2,1};densities{2,2};densities{2,3}],...
    [repmat({'L2'},size(densities{2,1}));...
    repmat({'L3'},size(densities{2,2}));...
    repmat({'L5'},size(densities{2,3}))]);
disp (['pvalue of exc syn density LPtA kruskallWallis test=',...
    num2str(pvalInhDensityLPtA)])