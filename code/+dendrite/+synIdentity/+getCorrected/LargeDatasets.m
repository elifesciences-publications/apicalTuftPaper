function [results] = LargeDatasets(skel,...
    synRatio,synDensity,results,verbose)
% LARGEDATASETS updates the results structures l235 field to add the
% corrected and uncorrected synapse density/inh. ratio
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('verbose','var') || isempty(verbose)
    verbose = false;
end
% Load axon switching fraction
axonSwitchFraction = dendrite.synIdentity.getCorrected.switchFactorl235;
layerOrigin = synDensity.uc.l235.Properties.VariableNames;
cellType = synDensity.uc.l235.Properties.RowNames;
synTypes = {'Spine','Shaft'};
% Initialize with empty tables
results.l235 = util.createTableTemplate(synRatio.uc.l235);
% Get the indices of skeletons for each of the layerOrigins and cellTypes
indexSkel = [1,1,1,1,1;2,2,2,0,3]';
indexCorrection = [1,2,2,1,3;1,2,3,1,4]';
% get corrected and uncorrected synapse density and ratios
for l = 1:length(layerOrigin)
    curFractionSwitch = axonSwitchFraction{1,l}{1};
    for c = 1:length(cellType)
        % Layer 2 marginal cells do not have a distal AD annotation
        if indexSkel(c,l) ~= 0
            curSkel = skel.l235{indexSkel(c,l)};
        else
            results.l235{c,l}{1} = [];
            continue
        end
        
        curTreeIdx = curSkel.groupingVariable.(cellType{c}){1};
        % Use the corrections of Deep for both L3 and L5 at the level of
        % L2. L5A however has its own shaft correction
        curCorrectionIndex = indexCorrection(c,l);
        curCorrection = curFractionSwitch{curCorrectionIndex,:};
        % Report
        if verbose
            fprintf(['For cell type: ',cellType{c},...
                '\nat: ',layerOrigin{l},...
                '\nSkeleton: ',curSkel.filename,'\n']);
            fprintf(['Correction: ',...
                axonSwitchFraction.Properties.VariableNames{l}...
                ,' of ',curFractionSwitch. ...
                Properties.RowNames{curCorrectionIndex},'\n\n']);
        end
        % Get corrected density/ratio
        curSynDensity = curSkel.getSynDensityPerType...
            (curTreeIdx,curCorrection);
        curRatio = curSkel.getSynRatio(curTreeIdx,curCorrection);
        % Join the corrected and uncorrected ratio and densities
        curRatio = join(synRatio.uc.l235{c,l}{1},curRatio,...
            'Keys',{'treeIndex'});
        curSynDensity = join(synDensity.uc.l235{c,l}{1},curSynDensity,...
            'Keys',{'treeIndex'});
        % Merge the uncorrected (first column) and corrected (second column)
        % synapse density and ratios
        for syn = 1:2
            varsRatio = contains(curRatio.Properties.VariableNames,...
                synTypes{syn});
            curRatio = mergevars...
                (curRatio,varsRatio,'NewVariableName',synTypes{syn});
            varsDensity = contains(curSynDensity.Properties.VariableNames,...
                synTypes{syn});
            curSynDensity = mergevars...
                (curSynDensity,varsDensity,'NewVariableName',synTypes{syn});
        end
        % Create Unique variableNames for joining
        curRatio.Properties.VariableNames(2:end) = cellfun(...
            @(x) [x,'_Ratio'],...
            curRatio.Properties.VariableNames(2:end),'uni',false);
        curSynDensity.Properties.VariableNames(2:end) = cellfun(...
            @(x) [x,'_Density'],...
            curSynDensity.Properties.VariableNames(2:end),'uni',false);
        results.l235{c,l}{1} = join(curRatio,curSynDensity,...
            'Keys','treeIndex');
    end
end

end

