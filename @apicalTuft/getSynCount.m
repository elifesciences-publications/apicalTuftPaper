function [ synapseCount] =...
    getSynCount( skel, treeIndices, switchCorrectionFactor)
% getSynCount returns the number of synapses per synapse group
% INPUT:
%       treeIndices: (Default:all trees) [1xN] or [Nx1] vector (colum or row)
%           Indices of trees
% OUTPUT:
%       synapseCount: table length(treeIndices) x length(SynapseFlags)+1
%           Containing single number showing the number of the
%           synapse type in the specific tree of the synapse Coords
%       switchCorrectionFactor: the fraction of axons in each group that
%       converts to the other. Used for correction of spine and shaft
%       synapses which are inhibitory and excitatory, respectively.
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Defaults
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees;
end
if ~exist('switchCorrectionFactor','var') || ...
        isempty(switchCorrectionFactor)
    switchCorrectionFactor = zeros(size(skel.synLabel));
end

% return empty table if empty annotation
if skel.connectedComp.emptyTracing
    synapseCount=table();
    return
end
if skel.connectedComp.splitDone
    synapseCount=skel.createEmptyTable(treeIndices,...
        skel.connectedComp.synIDPost.Properties.VariableNames);
    synapseCount{:,2:end}=...
        cellfun(@(x) sum(x(:,2)),...
        skel.connectedComp.synIDPost{treeIndices,2:end},'UniformOutput',false);
    synapseCount=[synapseCount(:,1),...
        util.varfunKeepNames(@cell2mat,synapseCount(:,2:end))];
else
    if any(switchCorrectionFactor~=0)
        % Make sure shaft synapses are the first column (matching the results
        % from the switch fraction calculation in: 
        % getAxonFractionWithReverseIdentity)
        assert(isequal(skel.synLabel,{'Shaft','Spine'}))
        % Correction factor for the inhibitory spine should equal zero and
        % only single spine and shaft should switch based on their
        % switchCorrection factor
        switchCorrectionFactor(3)=0;
        assert(isequal(skel.syn,...
            {'Shaft','spineSingleInnervated',...
            'spineDoubleInnervated','spineNeck'}));
        skel.synGroups={{3,4}'}';
        skel.synLabel={'Shaft','Spine','InhSpine'};
    end
    % Get node indices of the synapse groups
    synIdx=skel.getSynIdx( treeIndices);
    % Initialize synapse count the same way as the SynIdx
    synapseCount=array2table( zeros(size(synIdx,1),size(synIdx,2)-1),'VariableNames', ...
        synIdx.Properties.VariableNames(2:end));
    
    % get the synapse count
    synapseCount.Variables=cellfun(@length,...
        synIdx(:,2:end).Variables);
    % Apply the correction factor
    if any(switchCorrectionFactor~=0)
        totalRawSynNumber=sum(synapseCount.Variables,2);
        % Take out the number of double spines from the single spine group
        % Note: the excitatory synapse in a double innervated spine is
        % directly added to the single spine group since it is commented in
        % the same way. It makes sense to not count this as part of the
        % switching
        synapseCount.Spine=synapseCount.Spine-synapseCount.InhSpine;
        switchCount=synapseCount.Variables.*switchCorrectionFactor;
        % the count of switched spine synapses is moved to the shaft group
        % and vice versa
        synapseCount.Variables=synapseCount.Variables-switchCount+...
            switchCount(:,[2,1,3]);
        synapseCount.Shaft=synapseCount.Shaft+synapseCount.InhSpine;
        % Bring back the double innervated spine to the excitatory group
        synapseCount.Spine=synapseCount.Spine+synapseCount.InhSpine;
        synapseCount=removevars(synapseCount,'InhSpine');
        assert(...
            all(abs(sum(synapseCount.Variables,2)-totalRawSynNumber)<1e-8),...
        'Sums dont match before and after correction')
    end
    % Transfer treeIdx
    synapseCount=cat(2,synIdx(:,1),synapseCount);
end

end

