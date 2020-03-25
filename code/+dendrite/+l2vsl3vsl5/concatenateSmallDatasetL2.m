function [bifur] = concatenateSmallDatasetL2(bifur)
% concatenateSmallDatasetL2 Concatenate the density and Ratio values of the
% layer 2 cells in small datasets to the results from PPC2 dataset(bifur)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

bifurSkel = apicalTuft.getObjects('bifurcation');
bifurSkel = cellfun(@(x) x.sortTreesByName,bifurSkel,'uni',0);

smallDatasetRatios = apicalTuft.applyMethod2ObjectArray...
    (bifurSkel,'getSynRatio');
smallDatasetDensities = apicalTuft.applyMethod2ObjectArray...
    (bifurSkel,'getSynDensityPerType');
% Only keep the aggregate results from layer 2 PYR
smallDatasetRatios = smallDatasetRatios{1,5}{1};
smallDatasetDensities = smallDatasetDensities{1,5}{1};
% Get variables
b.shaftDensity = smallDatasetDensities.Shaft;
b.spineDensity = smallDatasetDensities.Spine;
b.shaftRatio = smallDatasetRatios.Shaft;

% Distance to soma as an additional variable in correlation plots
if isfield(bifur,'distance2soma')
    dist2SomaObj = apicalTuft.getObjects('dist2Soma');
    dist2SomaObj = cellfun(@(x) x.sortTreesByName,dist2SomaObj,'uni',0);
    % remove the whole trees from the dist2soma annotations
    indices2wholeTrees = cellfun(@(x) x.getTreeWithName...
        ('whole','partial'),dist2SomaObj,'uni',0);
    dist2SomaObj_wholeTreesRemoved = ...
        cellfun(@(x,y) x.deleteTrees(y),...
        dist2SomaObj,indices2wholeTrees,'uni',0);
    % Use bifurcaiton coordinate to match annotations between apicalDiameter
    % and bifurcation input mapping
    bifurCoordinates.inh = apicalTuft. ...
        applyMethod2ObjectArray(bifurSkel,'getBifurcationCoord',[],[],[],false);
    bifurCoordinates.SomaLoc = apicalTuft. ...
        applyMethod2ObjectArray...
        (dist2SomaObj_wholeTreesRemoved,'getBifurcationCoord',[],[],[],false);
    bifurCoordinates = structfun(@(x) x{1,5}{1},bifurCoordinates,...
        'UniformOutput',false);
    [~,index.inh,index.SomaLoc] = intersect(bifurCoordinates.inh,...
        bifurCoordinates.SomaLoc,'rows');
    % Correct the order of density/Ratios
    variables = fieldnames(b);
    for i = 1:length(variables)
        b.(variables{i}) = b.(variables{i})(index.inh);
    end
    % Get the distance to soma
    smallDatasetDistance2Soma = apicalTuft. ...
        applyMethod2ObjectArray...
        (dist2SomaObj_wholeTreesRemoved,'getSomaDistance',...
        [],[],[],'bifurcation');
    smallDatasetDistance2Soma = smallDatasetDistance2Soma{1,5}{1};
    b.distance2soma = cell2mat(smallDatasetDistance2Soma.distance2Soma);
    b.distance2soma = b.distance2soma(index.SomaLoc);
    % Tree names should be matching as well
    assert(isequal(smallDatasetDistance2Soma.treeIdx(index.SomaLoc),...
        smallDatasetRatios.treeIndex(index.inh)))
end
% Update the fields of bifur with layer 2 section from bifurcation mappings
% in smaller datasets
variables = fieldnames(bifur);
for i = 1:length(variables)
    bifur.(variables{i}){1} = [bifur.(variables{i}){1};...
        b.(variables{i})];
end

end

