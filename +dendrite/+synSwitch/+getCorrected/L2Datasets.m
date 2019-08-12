function [results] = L2Datasets(skel,...
    synRatio,synDensity)
%L2DATASETS Function to get the corrected bifurcation synRatio for smaller
% L2Datasets. The corrected output contains also the uncorrected values as
% the first column of a 2 column matrix for
% Load axon switching fraction
m=matfile(fullfile(util.dir.getAnnotation,'matfiles',...
    'axonSwitchFraction.mat'));
axonSwitchFraction=m.axonSwitchFraction;

apType={'l2Idx','dlIdx'};correctionName={'L2','Deep'};
synTypes={'Spine','Shaft'};
% Initialize with empty tables
results.bifur=util.createTableTemplate(synRatio.uc.bifur);
% get corrected and uncorrected synapse density and ratios
for apT=1:length(apType)
    for d=1:length(skel.bifur)
        curTreeIdx=skel.bifur{d}.(apType{apT});
        % Get the corrected synapse density and ratios
        curCorrection=axonSwitchFraction.L2{correctionName{apT},:};
        curSynDensity=skel.bifur{d}.getSynDensityPerType...
            (curTreeIdx,curCorrection);
        curRatio=skel.bifur{d}.getSynRatio(curTreeIdx,curCorrection);
        % Join the corrected and uncorrected ratio and densities
        curRatio=join(synRatio.uc.bifur{apT,d}{1},curRatio,...
            'Keys',{'treeIndex'});
        curSynDensity=join(synDensity.uc.bifur{apT,d}{1},curSynDensity,...
            'Keys',{'treeIndex'});
        % Merge the uncorrected (first column) and corrected (second column)
        % synapse density and ratios
        for syn=1:2
            varsRatio=contains(curRatio.Properties.VariableNames,...
                synTypes{syn});
            curRatio=mergevars...
                (curRatio,varsRatio,'NewVariableName',synTypes{syn});
            varsDensity=contains(curSynDensity.Properties.VariableNames,...
                synTypes{syn});
            curSynDensity=mergevars...
                (curSynDensity,varsDensity,'NewVariableName',synTypes{syn});
        end
        % Create Unique variableNames for joining
        curRatio.Properties.VariableNames(2:end)=cellfun(...
            @(x) [x,'_Ratio'],...
            curRatio.Properties.VariableNames(2:end),'uni',false);
        curSynDensity.Properties.VariableNames(2:end)=cellfun(...
            @(x) [x,'_Density'],...
            curSynDensity.Properties.VariableNames(2:end),'uni',false);
        results.bifur{apT,d}{1}=join(curRatio,curSynDensity,...
            'Keys','treeIndex');
    end
    % Create an aggregate Group as well
    results.bifur.Aggregate{apT}=cat(1,results.bifur{apT,:}{:});
end

end

