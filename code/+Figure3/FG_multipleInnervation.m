%% Fig. 3FG:  Extract multiple innervation of apical dendrites
% Annotation of multiple innervations:
% Multiple targeting of the seed AD is annotated as following:
% seed X: X is the number of times the seed is targeted
% Other AD-related synapses have an added _x at the end such as:
% spineOfDeepApicalDendrite_DoubleInnervated_1: first synapse on a
% double-innervated spine of deep apical dendrite

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%% Setup
util.clearAll;
skel = apicalTuft.getObjects('inhibitoryAxon');
outputDir = fullfile(util.dir.getFig(3),'FG');
util.mkdir(outputDir);
c = util.plot.getColors();

%% Extract multiple innervation from annotations
% Note: dimensions of the "results" cell array:
% cell array itself:
% dim 1: The dataset index
% array (within each cell):
% dim 1: Number of synapses on the AD target (minus seed AD)
% Note: All synapses onto the seed Apical dendrite is taken out for this
% analysis. Since the seed AD is chosen by us and thereby generates a bias.
% dim 2: Target (postsynaptic) apical dendrite type (1: L2, 2: dl)
% dim 3: Seed apical dendrite type (1: L2seeded, 2: DLseeded)
results = repmat({zeros(10,2,2)},1,4);
MultiPerDataset = cell(1,length(skel));
seedTypes = {'L2seeded','DLseeded'};
targetTypes = {'L2Apical','DeepApical'};
treeIdx = cell(size(skel));
for dsIndex = 1:length(skel)
    MultiPerDataset{dsIndex} = ...
        axon.multipleTargeting.extractMultipleTargeting...
        (skel{dsIndex});
    treeIdx{dsIndex}.L2seeded = skel{dsIndex}.l2Idx;
    treeIdx{dsIndex}.DLseeded = skel{dsIndex}.dlIdx;
    for seedT = 1:2
        % Pool data over trees of the same seed type(s = 1: L2seeded, 2:
        % DL-seeded)
        sT = seedTypes{seedT};
        curL2 = MultiPerDataset{dsIndex}...
            {treeIdx{dsIndex}.(sT),'L2Apical'};
        curDL = MultiPerDataset{dsIndex}...
            {treeIdx{dsIndex}.(sT),'DeepApical'};
        results{dsIndex}(:,:,seedT) = [sum(curL2,1)', sum(curDL,1)'];
    end
end
% Check the total number of synapses
axon.multipleTargeting.checkTotalSynapseNumber...
    (skel,MultiPerDataset,results)
% Sum results over datasets
allData = results{1}+results{2}+results{3}+results{4};

%% Text: Total Fraction of Targets with a single synapse in the EM volume (discarding the seed target)
fraction_targetMult = sum(allData,[2,3])./sum(allData,'all');
disp (['Total percent of targets with 1 synapse: ',...
    num2str(round(fraction_targetMult(1).*100,2))])

%% Write data to the excel file
% Data from individual axons
excelFileName = fullfile(util.dir.getExcelDir(3),'Fig3FG_IndvTrees.xlsx');
table2Write = cell2table(MultiPerDataset,'VariableNames',{'S1','V2','PPC','ACC'},...
    'RowNames',{'MultiInnervationMatrices'});
util.table.write(table2Write, excelFileName);
% Summary over trees of the same seed Type
rowNames = arrayfun(@(x) [num2str(x),' syn Per Target'],...
    1:10,'UniformOutput',false);
conv2TableFun = @(cEntry) array2table(reshape(results{cEntry},10,4),...
    'VariableNames',{'L2seeded_L2AD','L2seeded_DLAD','DLseeded_L2AD','DLseeded_DLAD'},...
    'RowNames',rowNames);
cellOFTableArrays = arrayfun(conv2TableFun, 1:length(results),...
    'UniformOutput',false);
table2Write_agg = cell2table(cellOFTableArrays, 'VariableNames', util.dsNames,...
    'RowNames',{'TargetsByTheNumberOfSynapse'});
excelFileName_Agg = fullfile(util.dir.getExcelDir(3),'Fig3FG_Agg.xlsx');
util.table.write(table2Write_agg, excelFileName_Agg);

%% For each axon calculate the average number of synapses on the AD targets
% Create an aggregate of the count of target with their known number of
% synapses
clear agg_synCountOnADTargets
agg_name = cellfun (@(x) [x,'_agg'],seedTypes,'uni',0);
for seedT = 1:2
    for dsIndex = 1:length(skel)
        % Separate the L2 and Deep seeded axon results from within each
        % dataset
        trIndices = treeIdx{dsIndex}.(seedTypes{seedT});
        agg_synMultDistribution.(seedTypes{seedT}){dsIndex} = ...
            MultiPerDataset{dsIndex}(trIndices,...
            targetTypes);
    end
    agg_synMultDistribution.(agg_name{seedT}) = ...
        cat(1,agg_synMultDistribution.(seedTypes{seedT}){:});
end
% Calculate the average number of synapses on each target. This only
% applies to cases where at least one synapse exists within that target
% group of specific axon types (L2 vs. DL seeded)
avgSynPerAxon = cell2table(cell(2,2),'VariableNames',targetTypes,...
    'RowNames',seedTypes);
for seedT = 1:height(avgSynPerAxon)
    for t = 1:width(avgSynPerAxon)
        % Get Distribution of the multi-innervation of ADs by axons seeded
        % from ADs
        curDist = agg_synMultDistribution.(agg_name{seedT}).(targetTypes{t});
        % Multiplying the distribution by the number of synapses for each
        % bin gives the total number of synapses (columns of curDist
        % represent the number of targets with the respective number of
        % synapses)
        curTotalSyn = sum(curDist.*(1:size(curDist,2)),2);
        % Getting total number of targets
        curTotalIndivTarget  = sum(curDist,2);
        % The ratio gives the
        curSynPerTarget = curTotalSyn ./ curTotalIndivTarget;
        % remove the nans  for axons with no synapse on target
        curSynPerTarget = curSynPerTarget(~isnan(curSynPerTarget));
        avgSynPerAxon{seedTypes{seedT},targetTypes{t}}{1} = curSynPerTarget;
    end
end
%% Write to excel
excelFileName = fullfile(util.dir.getExcelDir(3),'Fig3F_rawDatpoints.xlsx');
util.table.write(avgSynPerAxon, excelFileName);
%% Fig. 3f: Boxplot
fh = figure;ax = gca;
colors = repmat({c.l2color,c.dlcolor},1,2);
x_width = 2.5;
y_width = 2.5;
cellAvgPerAxon = avgSynPerAxon.Variables;
util.plot.boxPlotRawOverlay(cellAvgPerAxon(:),1:4,...
    'ylim',4.5,'boxWidth',0.5496,'color',colors(:),'tickSize',10);
yticks(0:4);yticklabels(0:4);
xticks([])
% Save fig
fname = fullfile(outputDir, 'meanAverage');
util.plot.cosmeticsSave...
    (fh,ax,x_width,y_width,[],[fname,'.svg']);

%% Wilcoxon ranksum test comparison of average number of synapses on target
% Figure legend 3f: Test separately for L2 and DL apical dendrite
% innervation. The goal is to see if axons seeded from
% L2 AD innervation
util.stat.ranksum(avgSynPerAxon{'L2seeded','L2Apical'}{1},...
    avgSynPerAxon{'DLseeded','L2Apical'}{1},...
    fullfile(outputDir,'L2ADInnervation_avgSynPerAxon'));
% DL AD innervation
util.stat.ranksum(avgSynPerAxon{'L2seeded','DeepApical'}{1},...
    avgSynPerAxon{'DLseeded','DeepApical'}{1},...
    fullfile(outputDir,'DLADInnervation_avgSynPerAxon'));
% Compare all L2-seeded vs. all DL-seeded by combining along the AD target
% type
util.stat.ranksum([avgSynPerAxon{1,1}{1};avgSynPerAxon{1,2}{1}],...
    [avgSynPerAxon{2,1}{1};avgSynPerAxon{2,2}{1}],...
    fullfile(outputDir,'L2seededvsDeepSeeded_avgSynPerAxon'));

%% Calculate fraction of AD type innervation (ignoring multiple innervation of the same target
targetFraction = cell(4,1);
for ds = 1:length(skel)
    for seedT = 1:2
        trIndices = treeIdx{ds}.(seedTypes{seedT});
        curTotal = sum(MultiPerDataset{ds}...
            {trIndices,{'L2Apical','DeepApical'}},2);
        curL2Target = sum(MultiPerDataset{ds}{trIndices,'L2Apical'},2);
        curDLTarget = sum(MultiPerDataset{ds}{trIndices,'DeepApical'},2);
        targetFraction{ds,seedT} = [curL2Target ./ curTotal,curDLTarget ./ curTotal];
        curSum = sum(targetFraction{ds,seedT},2);
        assert(all(curSum(~isnan(curSum)) == 1),'Check: Fraction sum to 1')
    end
end

%% comparison of L2 and DL-seeded axons for their innervation probability
% of L2 and DL innervation while ignoring multiple innervaiton of the same
% AD
ADFraction.l2Seeded = cat(1,targetFraction{:,1});
ADFraction.deepSeeded =  cat(1,targetFraction{:,2});
% remove nans
ADFraction.l2Seeded(isnan(ADFraction.l2Seeded(:,1)),:) = []; 
ADFraction.deepSeeded(isnan(ADFraction.deepSeeded(:,1)),:) = [];
% Ranksum test, results saved in the output Directory
fname = fullfile(outputDir,...
    'L2AD_TargetInnervationFraction');
util.stat.ranksum(ADFraction.l2Seeded(:,1),ADFraction.deepSeeded(:,1),fname);

%% Fig 3g: The innervation probability matrix
fractionAverage = ...
    reshape(struct2array(structfun(...
    @(x)mean(x,1),ADFraction,'UniformOutput',false)),2,2)';
fractionT = array2table(fractionAverage,'VariableNames',targetTypes,...
    'RowNames',seedTypes);
disp ('Fig.3g, fraction of innervation (ignore multi): ');
disp (fractionT);
util.plot.probabilityMatrix(...
    fractionAverage,fullfile(outputDir,...
    ['TheAvgOverAxons_IndividualTargetFraction','.svg']));