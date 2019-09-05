%% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
outputFolder=fullfile(util.dir.getFig3,'correctionforAxonSwitching');
util.mkdir(outputFolder)
results=dendrite.synSwitch.getCorrected.getAllRatioAndDensityResult;
%% L2 (smaller) datasets: Plotting correlation between corrected and not corrected
% synapse density and ratios
x_width=[2,1,1];
y_width=[2,1,1];
curResults=results.bifur.Aggregate;
limits=[1,1,5];
variables={'Shaft_Ratio','Shaft_Density','Spine_Density'};
dataset={'Aggregate'};
densityRatioForPlotBifur = dendrite.util.rearrangeArrayForPlot(results.bifur,...
    dataset,variables);
colors = {l2color,dlcolor};
mkrSize = 10;
for v=1:length(variables)
    fname=['L2Datasets',variables{v}];
    fh=figure('Name',fname);ax=gca;
    thisMeasure = densityRatioForPlotBifur.Aggregate.(variables{v});
    util.plot.correlation(thisMeasure,colors,[],mkrSize);
    dendrite.synSwitch.getCorrected.correlationFigCosmetics(limits(v),ax);
    util.plot.cosmeticsSave...
        (fh,ax,x_width(v),y_width(v),outputFolder,...
        [fname,'.svg'],'on','on');
end

%% Plotting celltype (larger datasets)
% Rearrange result table into cell array for input to correlation function
layerOrigin = {'mainBifurcation','distalAD'};
densityRatioForPlot = dendrite.util.rearrangeArrayForPlot(results.l235,...
    layerOrigin,variables);
colors=util.plot.getColors().l2vsl3vsl5;
% X and Y figure axis limits (layerOrigin, variable (density,ratio))
limits=[1,1,6;1,0.5,3];
for l = 1:length(layerOrigin)
    for v = 1:length(variables)
        fname = strjoin({variables{v},layerOrigin{l}},'_');
        fh=figure('Name',fname);ax=gca;
        hold on
        curLim = limits(l,v);
        thisMeasure = densityRatioForPlot.(layerOrigin{l}).(variables{v});
        util.plot.correlation(thisMeasure,colors,[],mkrSize);
        dendrite.synSwitch.getCorrected.correlationFigCosmetics(curLim,ax);
        hold off
        util.plot.cosmeticsSave...
            (fh,ax,x_width(v),y_width(v),outputFolder,[fname,'.svg'],...
            'on','on');
    end
end