function [results,L5stBeforeCorrection] = ...
    correctL5st_fordistal(skelL5A,results,...
    resultsWithTreeNames,layer)
% CORRECTL5ST_FORDISTAL Get the corrected values for L5st group
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
% get the correction fractions
axonSwitchFraction = dendrite.synIdentity.loadSwitchFraction;
switch layer
    case 'L1'
        L5stswitchFraction = axonSwitchFraction.L1...
            {'layer5AApicalDendriteSeeded',:};
        idxL5st = 1;
    case 'L2'
        L5stswitchFraction = axonSwitchFraction.L2{'L5A',:};
        idxL5st = 5;
    otherwise
        error('Layer unrecognized')
end
L5Atrees = skelL5A.groupingVariable.layer5AApicalDendrite_mapping{1};

% Get Corrected densities/fractions into a table
densityC = skelL5A.getSynDensityPerType(L5Atrees, L5stswitchFraction);
ratioC = skelL5A.getSynRatio(L5Atrees, L5stswitchFraction);
combinedCorrected = join(densityC,ratioC,...
    'Keys','treeIndex');

% Varibales for assigning
variableNames = {'inhFraction','inhDensity','excDensity'};
tableVariableNames = {'Shaft_corrected_ratioC',...
    'Shaft_corrected_densityC','Spine_corrected_densityC'};

% check tree names equality
assert(isequal(combinedCorrected.treeIndex,...
    resultsWithTreeNames.density{idxL5st,1}{1}.treeIndex));
assert(isequal(combinedCorrected.treeIndex,...
    resultsWithTreeNames.frac{idxL5st,1}{1}.treeIndex));
% Make sure that the L5st values are not already corrected (at least for
% the inhibitory fraction
assert(~isequal(combinedCorrected.Shaft_corrected_ratioC,...
    results.inhFraction{idxL5st}));
% Go over variables
for i = 1:3
    curUncorrected = results.(variableNames{i}){idxL5st};
    curCorrected = combinedCorrected.(tableVariableNames{i});
    % Keep track of fraction/density of synapses before correction for
    % later plotting
    L5stBeforeCorrection.(variableNames{i}) = curUncorrected;
    % Change values to corrected for plotting
    results.(variableNames{i}){idxL5st} = curCorrected;
end
end

