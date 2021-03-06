function [] = errorbarSpecificity ...
    (specificityArray,weightArray,color)
% ERRORBAR creates errorbar plot for innervation fraction of axons seeded
% from layer 2 and deep layer (L3/5) apical dendrites in Fig. 3D, 4B,C

% INPUT:
%       specificityArray:
%           array of tables containing the specificity,
%           result of getSynRatio method
%       weightArray:
%           array which should be similar in size and match the
%           1st dimension of each table
%       color:
%           cell array containing colors per tree

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~iscell(specificityArray)
    specificityArray = {specificityArray};
end

if ~iscell(color)
    color = {color};
end
if length(color) ~= length(specificityArray)
    color = repmat(color,length(specificityArray),1);
end
% If the weight array is not given use uniform weight. otherwise extract the
% weights from the table
if ~exist('weightArray','var') || isempty(weightArray)
    weightArray = cellfun(@(array)ones(size(array,1),1),...
        specificityArray,'UniformOutput',false);
else
    if istable(weightArray{1})
        weightArray = cellfun(@(table)table.weight,weightArray,...
            'UniformOutput',false);
    end
end

% iterate over the array of specificities create an errorbar per cell
for spec = 1:length(specificityArray)
    individualSpecificiy = specificityArray{spec};
    individualSpecificiyValues = individualSpecificiy{:,2:end};
    individualWeight = weightArray{spec};
    
    means = util.stat.mean(individualSpecificiyValues,individualWeight,1);
    sems = util.stat.sem(individualSpecificiyValues,individualWeight,1);
    errorbar(means,sems,'Color',color{spec});
end
% Figure properties
xticklabels(individualSpecificiy(:,2:end).Properties.VariableNames);
xtickangle(-45)
ylim([0 1]);
xlim([0.5 length(means)+0.5]);
end

