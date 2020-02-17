function [synCount] = getSynapseNumbers(apTuft)
%GETSYNAPSENUMBERS Gets synapse number of dendrites for text
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if apTuft{1,1}.legacyGrouping
    numberOfGroups=2;
    rowNames={'layer 2', 'Deep','Aggregate'};
    synapseCount=apicalTuft.applyMethod2ObjectArray(apTuft,...
    'getSynCount');
else
    numberOfGroups=5;
    rowNames={'layer 2', 'layer 3','layer 5',...
        'layer2MN','layer5A','Aggregate'};
    synapseCount=apicalTuft.applyMethod2ObjectArray(apTuft,...
    'getSynCount',true,true,'mapping');
end
synCountRaw=arrayfun(@(x) varfun(@sum,synapseCount.Aggregate{x}(:,2:end)),...
    1:numberOfGroups,'UniformOutput',false);
synCount=cat(1,synCountRaw{:});
sumPerApicalGroup=table(sum(synCount.Variables,2),'VariableNames',{'Sum'});
synCount=[synCount,sumPerApicalGroup];
sumPerType=varfun(@sum,synCount);

synCount=array2table([synCount.Variables;sumPerType.Variables],'RowNames',...
    rowNames,'VariableNames',{'Shaft','Spine','Sum'});
disp(synCount);
end

