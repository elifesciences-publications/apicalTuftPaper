function [synDensityPerType] = getSynDensityPerType( obj,treeIndices,...
    switchCorrectionFactor)
% getSynDensityPerType calculate synapse density (per um shaft path length) 
% per type of synapse present 
% The synapse types are defined under +config and the shaft backbone of the
% dendrite is used to get the path length
% INPUT:  
%       treeIndices: (Default:all trees)
%                   the indices of trees from skeleton
%       switchCorrectionFactor: (Default: zeros of size obj.synLabel)
%                   See getSynRatio
% OUTPUT: 
%       synDensityPerType: table
%       density of each synapse type 
% Note: The apicalTuft object should contain nonempty fixedEnding property 
%       for gettting the shaft backbone (spine necks removed).

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end
if ~exist('switchCorrectionFactor','var') || ...
        isempty(switchCorrectionFactor)
    switchCorrectionFactor = zeros(size(obj.synLabel));
end
% Measure pathlength of BackBone
pathLengthInMicron = obj.getBackBonePathLength(treeIndices);

% Get synapse count
synapseNr = obj.getSynCount(treeIndices,switchCorrectionFactor);
synDensityPerType = array2table( ...
    zeros(size(synapseNr,1),size(synapseNr,2)-1),'VariableNames', ...
    synapseNr.Properties.VariableNames(2:end));
synDensityPerType = cat(2,synapseNr(:,1),synDensityPerType);

% Measure Synapse density per shaft pathlength
synDensityPerType(:,2:end) = varfun(@(x) x./pathLengthInMicron.pathLengthInMicron,...
    synapseNr(:,2:end));
end

