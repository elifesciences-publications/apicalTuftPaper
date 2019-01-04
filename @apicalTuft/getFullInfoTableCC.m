function [allInfo] = getFullInfoTableCC(obj,treeIndices,...
synCountThresh,ccLengthThresh)
%GETFULLINFOTABLE This function gathers all the information regarding
% synapse count, density, CC pathlength and ratios used in Fig 3 analysis
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:length(obj.nodes);
end
if ~exist('synCountThresh','var') || isempty(synCountThresh)
    synCountThresh = 5;
end
if ~exist('ccLengthThresh','var') || isempty(ccLengthThresh)
    ccLengthThresh = 3;
end
if obj.connectedComp.emptyTracing
    allInfo=table();
    return
end
synCount=obj.getSynCount(treeIndices);
synCount.Properties.VariableNames=cellfun(@(x) [x,'_Count'],...
    synCount.Properties.VariableNames,'UniformOutput',false);
synThreshold=sum(synCount{:,2:end},2)>synCountThresh;

synRatio=obj.getSynRatio(treeIndices);
synRatio.Properties.VariableNames=cellfun(@(x) [x,'_Ratio'],...
    synRatio.Properties.VariableNames,'UniformOutput',false);

pathLength=obj.pathLength(treeIndices);
pathThresh=pathLength.pathLengthInMicron>ccLengthThresh;

synDensity=obj.createEmptyTable(treeIndices,cellfun(@(x) [x,'_Density'],...
    synCount.Properties.VariableNames,'UniformOutput',false),'double');
synDensity{:,2:end}=bsxfun(@rdivide,synCount{:,2:end},pathLength{:,2});

combinedThresh=synThreshold&pathThresh;
Thresholds=table(synThreshold,pathThresh,combinedThresh);

allInfo=[pathLength, synCount(:,2:end), synDensity(:,2:end),...
synRatio(:,2:end),Thresholds];

end

