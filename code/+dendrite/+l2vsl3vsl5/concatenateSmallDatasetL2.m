function [bifur] = concatenateSmallDatasetL2(bifur)
% concatenateSmallDatasetL2 Concatenate the density and Ratio values of the
% layer 2 cells in small datasets (S1, V2, PPC and ACC) to the results from
% the PPC-2 dataset

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

bifurSkel = apicalTuft.getObjects('bifurcation');
bifurSkel = cellfun(@(x) x.sortTreesByName,bifurSkel,'uni',0);

ratios_smallDs = apicalTuft.applyMethod2ObjectArray...
    (bifurSkel,'getSynRatio');
densities_smallDs = apicalTuft.applyMethod2ObjectArray...
    (bifurSkel,'getSynDensityPerType');
% Only keep the aggregate results from layer 2 PYR
L2ratios_smallDs = ratios_smallDs{1,5}{1};
L2ratios_smallDs.Properties.VariableNames(2:3) = ...
    {'inhFraction','excFraction'};
L2densities_smallDs = densities_smallDs{1,5}{1};
L2densities_smallDs.Properties.VariableNames(2:3) = ...
    {'inhDensity','excDensity'};
assert(isequal(L2ratios_smallDs.treeIndex,L2densities_smallDs.treeIndex),...
    'treeName check');
L2combined_smallDs = [L2densities_smallDs,L2ratios_smallDs(:,'inhFraction')];
% Check: Fraction of densities should give the ratio 
CheckDiff = L2combined_smallDs.inhFraction - ...
    (L2combined_smallDs.inhDensity./ ...
    (L2combined_smallDs.inhDensity+L2combined_smallDs.excDensity));
assert(all(CheckDiff < 1e-5), 'Fraction Check');

if isfield(bifur,'distance2soma')
    % Get dist2soma objects
    dist2SomaObj = apicalTuft.getObjects('dist2Soma');
    dist2SomaObj = cellfun(@(x) x.sortTreesByName,dist2SomaObj,'uni',0);
    % remove the whole trees from the dist2soma annotations
    indices2wholeTrees = cellfun(@(x) x.getTreeWithName...
        ('whole','partial'),dist2SomaObj,'uni',0);
    dist2SomaObj_wholeTreesRemoved = ...
        cellfun(@(x,y) x.deleteTrees(y),...
        dist2SomaObj,indices2wholeTrees,'uni',0);
    dist2soma_smallDs = apicalTuft. ...
        applyMethod2ObjectArray...
        (dist2SomaObj_wholeTreesRemoved,'getSomaDistance',...
        [],[],[],'bifurcation');
    L2dist2soma_smallDs = dist2soma_smallDs{1,5}{1};
    assert(isequal(L2combined_smallDs.treeIndex,L2dist2soma_smallDs.treeIdx),...
    'treeName check');
    L2combined_smallDs.distance2soma = ...
        cell2mat(L2dist2soma_smallDs.distance2Soma);
end

% Update the fields of bifur with layer 2 section from bifurcation mappings
% in smaller datasets
variables = fieldnames(bifur);
for i = 1:length(variables)
    bifur.(variables{i}){1} = [bifur.(variables{i}){1};...
        L2combined_smallDs.(variables{i})];
end

end

