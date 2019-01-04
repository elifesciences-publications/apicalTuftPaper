% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll

original.wholeApical=apicalTuft.getObjects('wholeApical');
original.bifurcation=apicalTuft.getObjects('bifurcation');
l235=apicalTuft.getObjects('l2vsl3vsl5');
original.dist2Soma=apicalTuft.getObjects('dist2Soma');
% Delete duplicate annotation betwen whole tracings and the bifurcations
original.dist2Soma=apicalTuft. ...
    deleteDuplicateBifurcations(original.dist2Soma);
original.bifurcation=apicalTuft. ...
    deleteDuplicateBifurcations(original.bifurcation);
% Keep only the layer 2 trees in each annotation
funl2dl=@(objArray) cellfun(@(obj) obj.deleteTrees(obj.l2Idx,true),objArray,...
    'UniformOutput',false);
onlyL2_l2dl=structfun(funl2dl,original,'UniformOutput',false);
funl235=@(obj) obj.deleteTrees...
    ([obj.groupingVariable.layer2ApicalDendrite_dist2soma{1};...
    obj.groupingVariable.layer2ApicalDendrite_mapping{1}],true);
onlyL2_l235=cellfun(funl235,l235,'UniformOutput',false);
% Get the additional distance to soma for PPC2 dataset, then delete the
% dist2soma trees for L2 PYR
trIndices=onlyL2_l235{1}.groupingVariable.layer2ApicalDendrite_dist2soma{1};
PPC2_additionalDist={cell2mat(onlyL2_l235{1}.getSomaDistance...
    (trIndices,'start').distance2Soma)};
onlyL2_l235{1}=onlyL2_l235{1}.deleteTrees(trIndices);
clear trIndices;

% Correct lowres voxel size in Z
onlyL2_l235{2} = onlyL2_l235{2}.correctionLowresLPtA;

% Merge bifurcations with whole apicalTrees
% Sort tree orders so distance to soma matches the order of the dense
% mappings
skel_mergedL2DL=cell(1,4);
skel_dist2Soma=cell(1,4);
for d=1:4
    skel_mergedL2DL{d}=onlyL2_l2dl.wholeApical{d}.mergeSkels...
        (onlyL2_l2dl.bifurcation{d});
    skel_dist2Soma{d}=onlyL2_l2dl.dist2Soma{d};
    % Sort Tress
    skel_mergedL2DL{d}=skel_mergedL2DL{d}.sortTreesByName;
    skel_dist2Soma{d}=skel_dist2Soma{d}.sortTreesByName;
    assert(isequal(skel_mergedL2DL{d}.names,skel_dist2Soma{d}.names));
end
% additional distance 2 soma calculated
skel_dist2Soma=cellfun(@(dSoma,mSkel) dSoma.matchTreeOrders(mSkel),...
    skel_dist2Soma,skel_mergedL2DL,'UniformOutput',false);
additionalDist_l2dl=cellfun(...
    @(skel) cell2mat(skel.getSomaDistance([],'start').distance2Soma),...
    skel_dist2Soma,'UniformOutput',false);
% Merge annotation and additional distance 2 soma
allSkels=[skel_mergedL2DL,onlyL2_l235];
allAdditionalDist=[additionalDist_l2dl,PPC2_additionalDist,{[]}];
% associate synapses with backbone nodes
skel_synIDOnBackBone=cellfun(@(x) x.associateSynWithBackBone,allSkels,...
    'UniformOutput',false);
% Measure distance of each synaspe to soma
tag2MeasureTowards={'start','start','start','start','start','soma'};
synDist2Soma=cellfun(...
    @(skel,tag,additionalDist) skel.relSomaDistance...
    ([],tag,additionalDist),...
    skel_synIDOnBackBone,tag2MeasureTowards,...
    allAdditionalDist,'UniformOutput',false);
% Add ratio of inhibitory synapses
distBins=0:10:330;
binCenters=5:10:325;
skel_synInhRatio=cellfun(...
    @(skel) skel.relSomaBinCountInhRatio([],distBins),synDist2Soma,...
    'UniformOutput',false);

%% Create aggregate plot
outputDir=fullfile(util.dir.getFig3,'dist2Soma');
util.mkdir(outputDir);
inhSyn=[];
excSyn=[];
fh=figure;ax=gca;
for sk=1:6
    inhSyn=[inhSyn;...
        cat(1,synDist2Soma{sk}.distSoma.synDistance2Soma.Shaft{:})];
    excSyn=[excSyn;...
        cat(1,synDist2Soma{sk}.distSoma.synDistance2Soma.Spine{:})];
end
inhBin=histcounts(inhSyn,distBins);
excBin=histcounts(excSyn,distBins);
inhSynRatio=inhBin./(inhBin+excBin);
plot(inhSynRatio);
xlabel('Distance to Soma along the apical dendrite');
ylabel('inhibitory synapse fraction');
util.plot.cosmeticsSave(fh,ax,20,14,outputDir,...
    'dist2Soma_L2PYRCells.png','on','on',false);
%% create the scatter plot
fh=figure;ax=gca;
hold on
for dataset=1:6
    ratios{dataset}=cat(1,skel_synInhRatio{dataset}. ...
        distSoma.acceptableInhRatios.acceptableRatios{:});
    distance{dataset}=repmat(binCenters, size(ratios{dataset},1),1);
    scatter(distance{dataset}(:),ratios{dataset}(:),[],l2color,'x');
end
allDist=cat(1,distance{:});
allDist=allDist(:);
allRatio=cat(1,ratios{:});
allRatio=allRatio(:);
indices=~isnan(allRatio);
allRatio=allRatio(indices);
allDist=allDist(indices);
[exp.f,exp.gof]=fit(allDist,allRatio,'exp2');

%plot(exp.f,'k');
legend('off')
xlabel([])
ylabel([])
xlim([0,max(distBins)]);
ylim([0,1]);
yticks(0:0.2:1)
%xlabel('Distance to Soma along the apical dendrite');
%ylabel('inhibitory synapse fraction');
util.plot.cosmeticsSave(fh,ax,10,5,outputDir,...
    'dist2Soma_L2PYRCells_scatter.svg','on','on',false);