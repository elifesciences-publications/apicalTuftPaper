% Clear all
util.clearAll;
%% Load skeleton an pia surface
pia = util.plot.loadPia;
skel = apicalTuft('PPC2_l2vsl3vsl5');
%% Get tree Indices of L5 and L5A neurons
dist2somaTreeIdx = skel.groupingVariable(:,...
    contains(skel.groupingVariable.Properties.VariableNames,'dist2soma'));
% Get tree Indices of L5tt and L5st neurons
tr_L5L5A = [dist2somaTreeIdx.layer5ApicalDendrite_dist2soma,...
    dist2somaTreeIdx.layer5AApicalDendrite_dist2soma];
somaDepth = cell(size(tr_L5L5A));
% Get their distance to pia
for cellT = 1:length(tr_L5L5A)
    curTr = tr_L5L5A{cellT};
    curNodes = skel.getNodesWithComment('soma',curTr,'insensitive');
    assert(length(curNodes)==length(curTr));
    curSomaCoords = skel.getNodes(curTr,curNodes);
    % convert to NM for plotting and distance to pia measurement and make
    % the first dimension XYZ
    curSomaCoordsInNM = round(curSomaCoords.*skel.scale)';
    % Measurement of distance to pia
    somaDepth{cellT}=...
    dendrite.L5A.somaDepth.dist2plane...
    (pia.fitSurfaceNM,curSomaCoordsInNM)./1000;
end

%% Plot box plot of comparison between somatic depth of L5tt and L5st cells 
% relative to pial surface

x_width=2;
y_width=1.9;
outputFolder=fullfile(util.dir.getFig5,...
    'somaDepthL5ttL5st');util.mkdir(outputFolder);
fname='somaDepthRelPia_L5vsL5A';
fh=figure('Name',fname);ax=gca;
util.setColors;
curColors={l5color,l5Acolor};
util.plot.boxPlotRawOverlay(somaDepth,1:2,...
    'boxWidth',0.4655,'color',curColors);
ylim([500,650]);
set(ax, 'YDir','reverse')
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    [fname,'.svg'],'off','on')

%% Statistical testing
util.stat.ranksum(somaDepth{1},somaDepth{2},...
    fullfile(outputFolder,'somaDepthL5tt_L5st'));

%% Also plot correlation between synaptic density/ratios and the somatic 
% depth
results = dendrite.synSwitch.getCorrected.getAllRatioAndDensityResult;
resultsL5 = results.l235.mainBifurcation([3,5])';
%% Plot
% Get corrected shaft ratio for L5tt and uncorrected shaft ratio for
% first row is uncorrected (L5tt) vs second row of each results is
% corrected (L5st)
curVars={'Shaft_Ratio','Shaft_Density','Spine_Density'};
indexCorrection = [1,2];
xWidth=2;yWidth=2;
for i=1:3
    fname=['CorrelationL5_SomaDepth_',curVars{i}];
    fh=figure('Name',fname);ax=gca;
    fullNameForText=fullfile(outputFolder,[fname,'.txt']);
    curMeasure= cell(1,2);
    % Concatenate soma diameter with the shaft,spine density/fraction
    for l5=1:2
        curMeasure{l5} = [resultsL5{l5}.(curVars{i})(:,indexCorrection(l5)),...
            somaDepth{l5}'];
    end
    % Plot with scatter with linear fit
    util.plot.correlation(curMeasure,{l5color,l5Acolor},...
        [],10,fullNameForText);
    util.plot.addLinearFit(curMeasure,[],true,...
        fullNameForText);
    set(gca,'YDir','reverse');
    ylim([500,650])
    util.plot.cosmeticsSave...
        (fh,ax,xWidth,yWidth,outputFolder,...
        [fname,'.svg'],'on','on');
end
%% Save the soma depth information
matfolder = fullfile(util.dir.getAnnotation,'matfiles',...
    'L5stL5ttFeatures');
util.mkdir (matfolder)
save(fullfile(matfolder,'somaDepth.mat'),'somaDepth');
