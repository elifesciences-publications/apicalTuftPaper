% This script extract features and tries to apply a clustering method to
% classification of L5 pyramidal neurons
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
saveResults = false
util.clearAll;
outputFolder=fullfile(util.dir.getFig5,...
    'ClassificationCriteriaForL5');
util.mkdir(outputFolder);

%% Get number of oblique dendrites per AD
skel_main = apicalTuft('PPC2_l2vsl3vsl5_oldL5Grouping');
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
curFeat = join(somaDiameter,curFeat,'Keys','RowNames',...
    'KeepOneCopy','somaDiameter');

%% main bifurcaiton depth
bifurcationDepth = dendrite.L5A.bifurcationDepth(skel_main,treeNamesL5);
curFeat = join(bifurcationDepth,curFeat,'Keys','RowNames',...
    'KeepOneCopy','bifurcationDepth');

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
k = 2;
Dist = pdist(X,'cosine');
clusterTree = linkage(Dist,'average');
fname = 'dendrogram';
fh = figure ('Name',fname);ax = gca;
x_width=2;
y_width=2;
H = dendrogram(clusterTree,'Labels',...
    cellfun(@(x) x(end-1:end),curFeat.Properties.RowNames,'uni',0),...
    'ColorThreshold','default');
xtickangle(-45)
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg'],'off','on');
disp(['Cophenet CC: ',num2str(cophenet(clusterTree, Dist))]);

clusters = cluster(clusterTree,'maxclust',k);
% Correct cluster IDs so that the L5tt group has ID 1 always
% Note: only works with k = 2
[~,Itt]=max(curFeat.numObliques);
if clusters(Itt) ~= 1
    clusters(clusters==1)= 2;
    clusters (clusters==2) = 1;
end
% summary stat of clusters
curFeat.clusters = clusters;

statsSummary = grpstats(curFeat,'clusters',{'mean','sem'});

%% do PCA on the features and make a plot
fname = 'PCA';
fh = figure ('Name',fname);ax = gca;
x_width=2;
y_width=2;
colors = {l5color,l5Acolor};
[~,scores] = pca(X);
hold on
for i=1:length(unique(clusters))
    util.plot.scatter(scores(clusters==i,1:2)',colors{i},10)
end
xlim ([-4,4]);ylim([-1.2,1.2]);
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,outputFolder,[fname,'.svg']);

%% Plot feature histograms
BinEdges = {[80:20:200],[0:1:20],[0:1:17],[0:0.4:3.4]};
curColors ={l5color,l5Acolor};
for f = 1:4
    curFeatName = curFeat.Properties.VariableNames{f};
    fh = figure ('Name',curFeatName);ax = gca;
    x_width=1.5;
    y_width=1;
    hold on
    for c=1:2
        indices = (curFeat.clusters == c);
        histogram(curFeat{indices,f},'BinEdges',BinEdges{f},...
            'DisplayStyle','stairs','EdgeColor', curColors{c});        
    end
    hold off
    xlim([0,max(BinEdges{f})+.5]);
    util.plot.cosmeticsSave...
        (fh,ax,x_width,y_width,outputFolder,...
        [curFeatName,'_histogram.svg'],'on','off');
end

%% Write out a new tree with renamed L5 neurons
% Reload the PPC2 annotation
skel_main = apicalTuft('PPC2_l2vsl3vsl5_oldL5Grouping');
annotationTypes = {'dist2soma','mapping'};
L5nameStubs= {'layer5ApicalDendrite','layer5AApicalDendrite'};
trIndices = cell(2,2);
newTrNames = cell(2,2);
for c=1:2
    % Get cluster trees sorted by the number of obliques
    linearIndices = find(clusters == c);
    [~,Isort]=sort(curFeat.numObliques(linearIndices),'descend');
    linearIndices = linearIndices(Isort);
    % Get name of trees
    trNames {1} = curFeat.Properties.RowNames(linearIndices);
    trNames {2} = cellfun(...
        @(x) strrep (x,annotationTypes{1},annotationTypes{2}),...
        trNames{1},'UniformOutput',false);
    assert (length(trNames{1}) == length(trNames{2}));
    for i=1:length(trNames)
        % Get their indices
        trIndices{i,c} = skel_main.getTreeWithName(trNames{i},'exact');
        % generate new tree names
        newTrNames{i,c} = arrayfun(...
            @(x) strjoin({L5nameStubs{c},[annotationTypes{i},num2str(x,'%0.2u')]},'_'),...
            1:length(trIndices{i,c}),'UniformOutput',false);
    end
end
%% correct tree names and save
if saveResults
    names = cell2table([skel_main.names(cat (1,trIndices{:})), cat(2,newTrNames{:})'],...
        'VariableNames',{'OldName','NewName'});
    skel_main.names(cat (1,trIndices{:})) = cat (2,newTrNames{:})';
    skel_main = skel_main.updateGrouping;
    skel_main.write ('PPC2_l2vsl3vsl5_L5newGrouping')
    % Save clustering treeNames
    save(fullfile(util.dir.getAnnotation,'matfiles','clusteringTreeNames.mat'),...
        'names');
end