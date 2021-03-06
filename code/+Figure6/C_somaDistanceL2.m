%% Fig. 6C: The inhibitory fraction on the apical dendrite of L2 neurons as a function of distance to soma
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

%% Setup
util.clearAll
outputDir = fullfile(util.dir.getFig(6),'C');
util.mkdir(outputDir);
c = util.plot.getColors();

%% Get skeletons
original.wholeApical = apicalTuft.getObjects('wholeApical');
original.bifurcation = apicalTuft.getObjects('bifurcation');
% Distance 2 soma for smaller datasets are in separate nml files
original.dist2Soma = apicalTuft.getObjects('dist2Soma');
% LPtA and PPC2 datasets
l235 = apicalTuft.getObjects('l2vsl3vsl5');
% Delete the L5A distal annotation
l235(3) = [];

%% Small dataset clean up
% Delete duplicate annotation betwen whole apical tracings and 
% the main bifurcations
originalNoDup.dist2Soma = apicalTuft. ...
    deleteDuplicateBifurcations(original.dist2Soma);
originalNoDup.bifurcation = apicalTuft. ...
    deleteDuplicateBifurcations(original.bifurcation);
originalNoDup.wholeApical = original.wholeApical;

% Keep only the layer 2 trees in each annotation
funl2dl = @(objArray) cellfun(@(obj) obj.deleteTrees(obj.l2Idx,true),objArray,...
    'UniformOutput',false);
onlyL2_l2dl = structfun(funl2dl,originalNoDup,'UniformOutput',false);

% Merge bifurcations with whole apicalTrees
% Sort tree orders so distance to soma matches the order of the dense
% mappings
skel_mergedL2DL = cell(1,4);
skel_dist2Soma = cell(1,4);
for d = 1:4
    skel_mergedL2DL{d} = onlyL2_l2dl.wholeApical{d}.mergeSkels...
        (onlyL2_l2dl.bifurcation{d});
    skel_dist2Soma{d} = onlyL2_l2dl.dist2Soma{d};
    % Sort Tress
    skel_mergedL2DL{d} = skel_mergedL2DL{d}.sortTreesByName;
    skel_dist2Soma{d} = skel_dist2Soma{d}.sortTreesByName;
    % Check tree name equality
    assert(isequal(skel_mergedL2DL{d}.names, skel_dist2Soma{d}.names));
end
% Get the additional distances
skel_dist2Soma = cellfun(@(dSoma,mSkel) dSoma.matchTreeOrders(mSkel),...
    skel_dist2Soma,skel_mergedL2DL,'UniformOutput',false);
additionalDist_l2dl = cellfun(...
    @(skel) cell2mat(skel.getSomaDistance([],'start').distance2Soma),...
    skel_dist2Soma,'UniformOutput',false);

%% PPC-2 and LPtA datasets
% Keep only L2/L2MN trees
funl235 = @(obj) obj.deleteTrees...
    ([obj.groupingVariable.layer2ApicalDendrite_dist2soma{1};...
    obj.groupingVariable.layer2ApicalDendrite_mapping{1};...
    obj.groupingVariable.layer2MNApicalDendrite_dist2soma{1};...
    obj.groupingVariable.layer2MNApicalDendrite_mapping{1}],true);
onlyL2_l235 = cellfun(funl235,l235,'UniformOutput',false);

% PPC-2: Get the additional distance (not included in the dense mapping) to 
% soma 
trIndices = [onlyL2_l235{1}.groupingVariable.layer2ApicalDendrite_dist2soma{1};...
    onlyL2_l235{1}.groupingVariable.layer2MNApicalDendrite_dist2soma{1}];
PPC2_additionalDist = {cell2mat(onlyL2_l235{1}.getSomaDistance...
    (trIndices,'start').distance2Soma)};
%  delete the dist2soma trees for L2 PYR
onlyL2_l235{1} = onlyL2_l235{1}.deleteTrees(trIndices);
clear trIndices;

% LPtA: Correct lowres voxel size in Z
onlyL2_l235{2} = onlyL2_l235{2}.correctionLowresLPtA;
% LPtA: Get additional soma distance 
LPtA_additionalSomaDistance = ...
    dendrite.L2Dist2SomaInhFractionAnalysis.getSomaDistanceLPtA...
    (onlyL2_l235{2});
% Delete the soma distance trees
onlyL2_l235{2} = onlyL2_l235{2}.deleteTrees...
    (onlyL2_l235{2}.groupingVariable.layer2ApicalDendrite_dist2soma{1});

%% Merge small dataset with PPC-2 and LPtA dataset annotations
allSkels = [skel_mergedL2DL,onlyL2_l235];
% Merge the additional distance to soma measured from the annotations in
% Low-res EM data
allAdditionalDist = [additionalDist_l2dl,PPC2_additionalDist,...
    {LPtA_additionalSomaDistance}];
% Associate synapses with their respective nodes on the shaft backbone 
skel_synIDOnBackBone = cellfun(@(x) x.associateSynWithBackBone,allSkels,...
    'UniformOutput',false);
% Measure distance of each synaspe to starting point, For all datasets an additional 
% tracing was used to get from starting point of main bifurcation tracing
% to soma
tag2MeasureTowards = {'start','start','start','start','start','newEndings'};
synDist2Soma = cellfun(...
    @(skel,tag,additionalDist) skel.relSomaDistance...
    ([],tag,additionalDist),...
    skel_synIDOnBackBone,tag2MeasureTowards,...
    allAdditionalDist,'UniformOutput',false);
% Add ratio of inhibitory synapses
distBins = 0:10:330;
binCenters = 5:10:325;
skel_synInhRatio = cellfun(...
    @(skel) skel.relSomaBinCountInhRatio([],distBins),synDist2Soma,...
    'UniformOutput',false);
%% numbers for methods, 
% make sure the total synapse numbers match before and after chopping
disp(['Total AD number: ',...
    num2str(sum(cellfun(@(x) length(x.names),allSkels)))]);
disp(['Total synapse number: ',...
    num2str(sum(cellfun(...
    @(x)sum(x.getTotalSynNumber.totalSynapseNumber),allSkels)))]);
disp(['Total synapse number (from individual chopped trees): ',...
    num2str(sum(cellfun(@(x) x.distSoma.total,skel_synInhRatio)))]);

%% create the scatter plot
fh = figure;ax = gca;
mkrSize = 10;
hold on
ratios = cell(1,6);
distance = cell(1,6);
for dataset = 1:6
    ratios{dataset} = cat(1,skel_synInhRatio{dataset}. ...
        distSoma.acceptableInhRatios.acceptableRatios{:});
    distance{dataset} = repmat(binCenters, size(ratios{dataset},1),1);
    % Scatter plot
    scatter(distance{dataset}(:),ratios{dataset}(:),mkrSize,c.l2color,'x');
end

% Figure properties
legend('off')
xlabel([])
ylabel([])
xlim([0,max(distBins)]);
ylim([0,1]);
yticks(0:0.2:1)
util.plot.cosmeticsSave(fh,ax,4,2.6,outputDir,...
    'dist2Soma_L2PYRCells_scatter.svg','on','on',false);

%% Write data to excel sheet
rowNames = arrayfun(@(x) [num2str(x),'um'],binCenters, 'uni',0);
allRatiosT = cell2table(cell(1,6),'RowNames',{'InhibitoryFraction'},...
    'VariableNames',[util.dsNames,'PPC2','LPtA']);
for dataset = 1:6
    curTreeNames = skel_synInhRatio{dataset}.distSoma. ...
        acceptableInhRatios.treeIdx;
    curRatioT = array2table(ratios{dataset}','VariableNames',curTreeNames,...
        'RowNames',rowNames);
    allRatiosT{1,dataset}{1} = curRatioT;
end
excelFileName = fullfile(util.dir.getExcelDir(6),'Fig6C.xlsx');
util.table.write(allRatiosT, excelFileName);