function [out] = ...
    getRatioDensities(skel)
% GETRATIODENSITIES Get ratio and densities in the form which can be used
% for plotting
cellTypeRatios = skel.applyMethod2ObjectArray({skel},...
    'getSynRatio',[],false,'mapping');
cellTypeDensity = skel.applyMethod2ObjectArray({skel},...
    'getSynDensityPerType',[],false,'mapping');
% Remove empty cell type groups
index = ~cellfun(@isempty,cellTypeRatios.Variables);
cellTypeRatios = cellTypeRatios(index,:);
cellTypeDensity = cellTypeDensity(index,:);

% Create cell arrays used for plotting
out.shaftRatio = cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
out.shaftDensity = cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
out.spineDensity = cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);
end

