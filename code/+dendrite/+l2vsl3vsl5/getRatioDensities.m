function [out,cellTypeRatios,cellTypeDensity] = ...
    getRatioDensities(skel)
% GETRATIODENSITIES Get ratio and densities in the form which can be used
% for plotting

% Author: Ali Karimi<ali.karimi@brain.mpg.de>

cellTypeRatios = skel.applyMethod2ObjectArray({skel},...
    'getSynRatio',[],false,'mapping');
cellTypeDensity = skel.applyMethod2ObjectArray({skel},...
    'getSynDensityPerType',[],false,'mapping');
% Remove empty cell type groups
index = ~cellfun(@isempty,cellTypeRatios.Variables);
cellTypeRatios = cellTypeRatios(index,:);
cellTypeDensity = cellTypeDensity(index,:);

% Create cell arrays used for plotting
out.inhFraction = cellfun(@(x) x.Shaft,cellTypeRatios.Variables,...
    'UniformOutput',false);
out.inhDensity = cellfun(@(x) x.Shaft,cellTypeDensity.Variables,...
    'UniformOutput',false);
out.excDensity = cellfun(@(x) x.Spine,cellTypeDensity.Variables,...
    'UniformOutput',false);
end

