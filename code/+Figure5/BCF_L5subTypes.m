%% Fig. 5B, C, F: Classification of L5 neurons into slender- and thick-tufted subtypes
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% Set-up
util.clearAll;
saveNewL5Grouping = false;
outputFolder = fullfile(util.dir.getFig(5),...
    'BCF');
util.mkdir(outputFolder);
c = util.plot.getColors();

%% Get number of oblique dendrites per AD
% Note: The L5 neurons were first only classified based on only the Soma
% diameter resulting in 12 L5tt and 6 L5st neurons. Using this script we
% then classified them using the 4 features you see in the following
% sections. To start, we first load the annotation with the previous (old)
% classification
warning off
skel_main = apicalTuft('PPC2_l2vsl3vsl5_oldL5Grouping');
warning on
IdxL5_dist2soma = [skel_main.groupingVariable.layer5ApicalDendrite_dist2soma{1};...
    skel_main.groupingVariable.layer5AApicalDendrite_dist2soma{1}];
% Initial classification
curG = categorical([repmat({'L5tt'},12,1);repmat({'L5st'},6,1)]);
% Get the number of oblique dendrites
[numObliques,Coords] = skel_main.getNumberOfObliques(IdxL5_dist2soma);

%% Get Diameter of the AD trunks
fileName = fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_ApicalTrunkDiameter.nml');
skel_ADDiameter = skeleton(fileName);
treeNamesL5 = skel_main.names(IdxL5_dist2soma);
% Get the diameter
ADTrunkD = dendrite.L5.getADTrunkDiameter(skel_ADDiameter,treeNamesL5);
% Combine diameter and number of obliques
L5features = join(numObliques,ADTrunkD,'Keys','RowNames');

%% Get the diameter of the soma
fileName = fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_somaDiameter.nml');
skel_SomaD = skeleton(fileName);
% Get the volume and diameter from measurements of format:
% treename_01,02,03: the three diameters
[somaDiameter] = dendrite.L5.getSomaSize(skel_SomaD,treeNamesL5);
L5features = join(somaDiameter,L5features,'Keys','RowNames',...
    'KeepOneCopy','somaDiameter');

%% main bifurcaiton depth
bifurcationDepth = dendrite.L5.bifurcationDepth(skel_main,treeNamesL5);
L5features = join(bifurcationDepth,L5features,'Keys','RowNames',...
    'KeepOneCopy','bifurcationDepth');

%% Clustering: Normalize data
featuresNormalized = ...
    zscore(L5features.Variables,[],1);
L5features.featuresNormalized = featuresNormalized;

%% Clsutering: Grid search for hierarchichal clustering method and metric
% X: The matrix of the data. Rows are different L5 neurons and the columns
% represent 4 variables. See above for the method of acquiring each
% variable.
% Set-up distance metrics and linkage methods
distMetricNames = {'euclidean','squaredeuclidean','seuclidean',...
    'mahalanobis','cityblock','minkowski','chebychev','cosine',...
    'correlation','hamming','jaccard','spearman'};
linkageMethodNames = {'average','centroid','complete','median','single',...
    'ward','weighted'};
% Use cophenetic correlation as the metric
correlationC = zeros(length(distMetricNames), length(linkageMethodNames));
warning off
for r = 1:length(distMetricNames)
    for h = 1:length(linkageMethodNames)
        curMetric = distMetricNames{r};
        curMethod = linkageMethodNames{h};
        Dist = pdist(featuresNormalized,curMetric);
        clusterTree = linkage(Dist,curMethod);
        correlationC(r,h) = cophenet(clusterTree, Dist);
    end
end
warning on
% Get best method and distance metric for linking individual L5 neurons
[~,I_method] = max(mean(correlationC,1));
[~,I_metric] = max(mean(correlationC,2));
% Disp results
disp(['Best method is: ',linkageMethodNames{I_method}]);
disp(['Best metric is: ',distMetricNames{I_metric}]);

%% Clustering: Perform the clustering using the parameters from previous section
numClusters = 2;
Dist = pdist(featuresNormalized,'cosine');
clusterTree = linkage(Dist,'average');
fname = 'C_dendrogram';
fh = figure ('Name',fname);ax = gca;
x_width = 2;
y_width = 2;
H = dendrogram(clusterTree,'Labels',...
    cellfun(@(x) x(end-1:end),L5features.Properties.RowNames,'uni',0),...
    'ColorThreshold','default');
xtickangle(-45)
% Note: The colors of the dendrogram are manually corrected in illustrator
% so the appearance is different from the panel Fig. 5c
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg'],'off','on');
disp(['Cophenet CC: ',num2str(cophenet(clusterTree, Dist))]);

L5ClusterIdx = cluster(clusterTree,'maxclust',numClusters);

% Correct cluster IDs so that the L5tt group has Idx = 1 and L5st has
% Idx = 2, only works with numClusters = 2.
% Max number of oblique dendrites should be a L5tt (manually checked)
[~,Idxtt] = max(L5features.numObliques);
if L5ClusterIdx(Idxtt) ~= 1
    L5ClusterIdx(L5ClusterIdx == 1)= 2;
    L5ClusterIdx (L5ClusterIdx == 2) = 1;
end
% summary stat of clusters
L5features.clusters = L5ClusterIdx;
statsSummary = grpstats(L5features,'clusters',{'mean','sem'});

%% PCA on the 4-D feature space
fname = 'C_PCA';
fh = figure ('Name',fname);ax = gca;
x_width = 2;
y_width = 2;
colors = {c.l5color,c.l5Acolor};
% Get the principal component score for each L5 neuron
[~,scores] = pca(featuresNormalized);
hold on
% Idx 1 is L5tt and 2 is L5st
for clIdx = 1:length(unique(L5ClusterIdx))
    util.plot.scatter(scores(L5ClusterIdx == clIdx,1:2)',colors{clIdx},10);
end
xlim([-4,4]); ylim([-1.2,1.2]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg']);
L5features.PCAscores = scores;
%% Fig. 5B: Plot feature histograms
% Bin edges for different features
BinEdges = {80:20:200,0:1:20,0:1:17,0:0.4:3.4};
x_width = 1.5;
y_width = 1;
% Loop over main features and plot histogram
for f = 1:4
    curFeatName = ['B_',L5features.Properties.VariableNames{f}];
    fh = figure ('Name',curFeatName);ax = gca;
    hold on
    for cl = 1:2
        subTypeIdx = (L5features.clusters == cl);
        histogram(L5features{subTypeIdx,f},'BinEdges',BinEdges{f},...
            'DisplayStyle','stairs','EdgeColor', colors{cl});
    end
    hold off
    xlim([0,max(BinEdges{f})+.5]);
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,...
        [curFeatName,'_histogram.svg'],'on','off');
end

%% Write out a new tree with renamed L5 neurons

% Tree name components
annotationTypes = {'dist2soma','mapping'};
L5nameStubs= {'layer5ApicalDendrite','layer5AApicalDendrite'};
matfileName = fullfile(util.dir.getMatfile,'clusteringTreeNames.mat');
% Initialize variables
trIndices = cell(2,2);
newTrNames = cell(2,2);
% Loop over the two clusters (cl 1: L5tt cl 2: L5st)
for cl = 1:2
    % Get current L5 subtype trees sorted by the number of obliques
    linearIndices = find(L5ClusterIdx == cl);
    [~,Isort] = sort(L5features.numObliques(linearIndices),'descend');
    linearIndices = linearIndices(Isort);
    % Get name of trees
    trNames{1} = L5features.Properties.RowNames(linearIndices);
    trNames{2} = cellfun(...
        @(x) strrep (x,annotationTypes{1},annotationTypes{2}),...
        trNames{1},'UniformOutput',false);
    assert (length(trNames{1}) == length(trNames{2}));
    for trIdx = 1:length(trNames)
        % Get their indices
        trIndices{trIdx,cl} = skel_main.getTreeWithName(trNames{trIdx},'exact');
        % generate new tree names
        newTrNames{trIdx,cl} = arrayfun(...
            @(x) strjoin({L5nameStubs{cl},[annotationTypes{trIdx},num2str(x,'%0.2u')]},'_'),...
            1:length(trIndices{trIdx,cl}),'UniformOutput',false);
    end
end
% correct tree names and save
names = cell2table([skel_main.names(cat (1,trIndices{:})), cat(2,newTrNames{:})'],...
    'VariableNames',{'OldName','NewName'});
nameMap = containers.Map(names.OldName,names.NewName);
% Check against the saved treeNames:
matF = load(matfileName);
assert(isequal(names,matF.names),'Check aginst saved mat file');
% Saving
if saveNewL5Grouping
    % Update tree names
    skel_main.names(cat(1,trIndices{:})) = cat(2,newTrNames{:})'; %#ok<UNRCH>
    skel_main = skel_main.updateGrouping;
    skel_main.write ('PPC2_l2vsl3vsl5_L5newGrouping')
    % Save clustering treeNames
    save(matfileName,'names');
end
%% Get the correction fraction and treeIndices for synapse densities
% Get the Idx of the synapse annotations at the main bifurcation ("mapping")
curMappingNames = cellfun (@(x)strrep(x,'dist2soma','mapping'),...
    skel_main.names(IdxL5_dist2soma),'UniformOutput',false);
IdxL5_mapping = skel_main.getTreeWithName(curMappingNames,'exact');

% Plot scores vs. inhibitory fractions
axonSwitchFraction = dendrite.synIdentity.getCorrected.switchFactorl235;
correctionFrac = axonSwitchFraction.mainBifurcation{1}{'L5A',:};

%% Linear relationship between synapse densities and the first PC (Thick-tuftedness)
% First get the L5st-corrected densities for L5tt and L5st
synapseDensity = ...
    skel_main.getSynDensityPerType(IdxL5_mapping,correctionFrac);
% L5tt (cluster 1): Get the uncorrected values
synapseDensity(L5ClusterIdx == 1,:) = ...
    skel_main.getSynDensityPerType(IdxL5_mapping(L5ClusterIdx == 1));
synapseDensity.Properties.VariableNames(2:3) = ...
    {'PutativeInhibitory','Excitatory'};
% Add to L5 features
convert_DistName = @(x) cellfun(@(d) strrep(d,'mapping','dist2soma'),...
    x,'UniformOutput',false);
trName_synIdx = convert_DistName(synapseDensity.treeIndex);
assert(isequal(L5features.Row,trName_synIdx), 'Check: Tree names match');
L5features = [L5features,synapseDensity(:,2:3)];
% Set different limits for excitatory and inhibitory graphs
ylimit = [0,0.3,4];
linearModel = cell(1,2);

for synT = 1:2
    % First variable is the tree names
    g = synT+1;
    fname = ['F_',synapseDensity.Properties.VariableNames{g}];
    fh = figure('Name', fname);ax = gca;
    x_width = 1.5;
    y_width = 1.5;
    hold on
    scores_Cell = cell(1,2);
    curDensity = cell(1,2);
    combinedArray = cell(1,2);
    for clIdx = 1:2
        scores_Cell{clIdx} = scores(L5ClusterIdx == clIdx,1);
        curDensity{clIdx} = synapseDensity{L5ClusterIdx == clIdx,g};
        combinedArray{clIdx} = [scores_Cell{clIdx},curDensity{clIdx}];
        util.plot.scatter([scores_Cell{clIdx},curDensity{clIdx}]',colors{clIdx});
    end
    fullname = fullfile(outputFolder,[fname,'.txt']);
    linearModel{synT} = util.plot.addLinearFit(combinedArray,[],fullname);
    hold off
    % Plot the exponential
    ylim([0,ylimit(g)]);xlim([-3 4]);
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,...
        [fname,'.svg'],'on','on');
end

%% Inhibitory ratio
% First get the corrected values for all
inhRatio = skel_main.getSynRatio...
    (IdxL5_mapping,correctionFrac).Shaft_corrected;
% Get the raw values for L5tt
inhRatio(L5ClusterIdx == 1) = ...
    skel_main.getSynRatio(IdxL5_mapping(L5ClusterIdx == 1)).Shaft;
% Add to L5 features
assert(isequal...
    (convert_DistName(skel_main.getSynRatio(IdxL5_mapping).treeIndex),...
    L5features.Row));
L5features.putativeInhibitoryFraction = inhRatio;
% Scatter plot
fh = figure;ax = gca;
y_width = 4.5;
x_width = 3;
hold on
inhRatio_Cell = cell(1,2);
for i = 1:2
    scores_Cell{i} = scores(L5ClusterIdx == i,1);
    inhRatio_Cell{i} = inhRatio(L5ClusterIdx == i);
    combinedArray{i} = [scores_Cell{i},inhRatio_Cell{i}];
    util.plot.scatter([scores_Cell{i},inhRatio_Cell{i}]',colors{i});
end
% combine L5st and tt groups
allX = cat(1,scores_Cell{:});
allY = cat(1,inhRatio_Cell{:});

% Plot the combination of linear fits to the synatptic densities
% combine excitatory and inhibitory model coefficients to get the
% inhibitory fraction fit from the two linear fits
combinedCoeffs = fliplr(linearModel{1}.Coefficients.Estimate' + ...
    linearModel{2}.Coefficients.Estimate');
inhCoeff = fliplr(linearModel{1}.Coefficients.Estimate');
excCoeff = fliplr(linearModel{2}.Coefficients.Estimate');

minMax = [min(allX), max(allX)];
% inh / (inh+exc)
modelRatioFun = @(x) arrayfun(@(y)(inhCoeff *[y;1])/(combinedCoeffs*[y;1]),x);
util.plot.genericModel(modelRatioFun,minMax,'k--');

% Get the coefficient of determination
numParams = 4;
combinedRsquared.total = ...
    util.stat.coeffDetermination(modelRatioFun,[allX,allY],numParams);
ylim([0,0.5]);xlim([-3 4]);
%% Fit nonlinear model with form (b(1)x+b(2)/b(3)x+b(4)) to inhibitory fraction
bilinearModel = @(b,x) (b(1)*x+b(2))./ (b(3)*x+b(4));
beta0 = [inhCoeff,combinedCoeffs];
fname = fullfile(outputFolder,'nonLinear_RatioModel.txt');
bilinearFit = util.plot.addNonLinearFit({[allX,allY]}, bilinearModel, ...
    true,fname,[inhCoeff,combinedCoeffs],'-');


%% Fit only inhibitory or excitatory model
avgInh = mean(synapseDensity.PutativeInhibitory);
avgExc = mean(synapseDensity.Excitatory);

modelOnlyExc = @(x) arrayfun(@(y) avgInh/(avgInh+excCoeff*[y;1]),x);
modelOnlyInh = @(x) arrayfun(@(y)(inhCoeff *[y;1])/((inhCoeff*[y;1])+avgExc),x);

util.plot.genericModel(modelOnlyExc,minMax,'r--');
util.plot.genericModel(modelOnlyInh,minMax,'b--');

numParams = 2;
combinedRsquared.Inh = util.stat.coeffDetermination(modelOnlyInh,[allX,allY],numParams);
combinedRsquared.Exc = util.stat.coeffDetermination(modelOnlyExc,[allX,allY],numParams);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,...
    'F_InhFrac_PC1.svg','on','on',false);
%% Write clustering results to excel sheet
excelFileName = fullfile(util.dir.getExcelDir(5),'Fig1BCF.xlsx');
% Update the tree names to the current version
L5features.Row = cellfun(@(x)nameMap(x),L5features.Row,...
    'UniformOutput',false);
L5features = sortrows(L5features,'RowNames');
writetable(L5features, excelFileName, 'WriteRowNames', true);