% This script extract features and tries to apply a clustering method to
% classification of L5 pyramidal neurons
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

util.clearAll;
outputFolder=fullfile(util.dir.getFig5,...
    'ClassificationCriteriaForL5');
util.mkdir(outputFolder);
%% Get number of oblique dendrites per AD
skel_main = apicalTuft('PPC2_l2vsl3vsl5');
IdxL5 = [skel_main.groupingVariable.layer5ApicalDendrite_dist2soma{1};...
    skel_main.groupingVariable.layer5AApicalDendrite_dist2soma{1}];
curG = categorical([repmat({'L5tt'},12,1);repmat({'L5st'},6,1)]);
[numObliques,Coords] = skel_main.getNumberOfObliques(IdxL5);

%% GetDiameter of the AD trunks
fileName = fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_ApicalTrunkDiameter.nml');
skel_ADDiameter = skeleton(fileName);
treeNamesL5 = skel_main.names(IdxL5);
ADTrunkD = dendrite.L5A.getADTrunkDiameter(skel_ADDiameter,treeNamesL5);
curFeat = join(numObliques,ADTrunkD,'Keys','RowNames');
%% Get the diameter of the soma
fileName=fullfile(util.dir.getAnnotation,...
    'otherAnnotations','PPC2_somaDiameter.nml');
skel_SomaD = skeleton(fileName);
% Get the volume and diameter from measurements of format:
% treename_01,02,03: the three diameters
[somaDiameter]=dendrite.L5A.getSomaSize(skel_SomaD,treeNamesL5);
curFeat = join(curFeat,somaDiameter,'Keys','RowNames');
%% main bifurcaiton depth
bifurcationDepth = dendrite.L5A.bifurcationDepth(skel_main,treeNamesL5);
curFeat = join(curFeat,bifurcationDepth,'Keys','RowNames');

%% Clustering
%% Normalize data
curFeatNormalized = curFeat;
curFeatNormalized.Variables = ...
zscore(curFeat.Variables,[],1);
% K-means
[cidx2,cmeans2] = ...
    kmeans(curFeatNormalized.Variables,2,'dist','sqeuclidean');
%% Hierarchichal clustering

% Grid search over distance metric and method
X = curFeatNormalized.Variables;
distMetricNames = {'euclidean','squaredeuclidean','seuclidean',...
    'mahalanobis','cityblock','minkowski','chebychev','cosine',...
    'correlation','hamming','jaccard','spearman'};
linkageMethodNames = {'average','centroid','complete','median','single',...
    'ward','weighted'};

for r=1:length(distMetricNames) 
    for h=1:length(linkageMethodNames)
        curMetric = distMetricNames{r};
        curMethod = linkageMethodNames{h};
        Dist = pdist(X,curMetric);
        clusterTree = linkage(Dist,curMethod);
        correlationC(r,h) = cophenet(clusterTree, Dist);
    end
end
% Get best method and distance metric for linking individual L5 neurons
[~,I_method] = max(mean(correlationC,1));
[~,I_metric] = max(mean(correlationC,2));

disp(['Best method is: ',linkageMethodNames{I_method}]);
disp(['Best metric is: ',distMetricNames{I_metric}]);
%% Perform the clustering using the parameters from previous section
k =2;
Dist = pdist(X,'cosine');
clusterTree = linkage(Dist,'average');
dendrogram(clusterTree);
disp(['Cophenet CC: ',num2str(cophenet(clusterTree, Dist))]);
I = inconsistent(clusterTree);
clusters = cluster(clusterTree,'maxclust',k);
% summary stat of clusters
curFeat.clusters = clusters;
statsSummary = grpstats(curFeat,'clusters',{'mean','sem'});

%% Look at the synapse ratios around their main bifurcations
% 1:middle, 2: L5st, 3:L5tt
trIndicesCluster = cell(length(unique(clusters)),1);
curMappingNames = cell(length(unique(clusters)),1);
for curCluster = unique(clusters)'
    treeIndicesInRow = (curFeat.clusters == curCluster);
    curNames = curFeat.Properties.RowNames(treeIndicesInRow);
    curMappingNames{curCluster} = cellfun (@(x)strrep(x,'dist2soma','mapping'),curNames,...
        'UniformOutput',false);
    curIndices = skel_main.getTreeWithName(curMappingNames{curCluster},'exact');
    assert (length(curIndices) == sum(treeIndicesInRow));
    trIndicesCluster{curCluster} = curIndices;
end

%% Save the names inside each cluster for use later
save(fullfile(util.dir.getAnnotation,'matfiles','clusteringTreeNames'),...
    'curMappingNames');
%% Get the synaptic ratio
clusterInhRatios = cell(1,k);
for i = 1:length(trIndicesCluster)
    curIndices = trIndicesCluster{i};
    clusterInhRatios{i} = skel_main.getSynDensityPerType(curIndices).Spine;
end

%% Plotting
outputFolder = fullfile(util.dir.getFig5,...
    'clusteringL5Cells');
colors = {l5color,l5Acolor};
indices = 1:k;
fname = 'inhibitoryRatioClusters3';
fh = figure ('Name',fname);ax = gca;
x_width=2;
y_width=3;
util.plot.boxPlotRawOverlay(clusterInhRatios,indices,'boxWidth',0.5496,...
    'color',colors);
xticks(1:max(indices));
yticks(0:0.2:1);
xlim([0.5, max(indices)+.5]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg']);

%% Statistical testing on the synapse ratios of different clusters
testResults = util.stat.KW (clusterInhRatios,{'L5?','L5st','L5tt'});