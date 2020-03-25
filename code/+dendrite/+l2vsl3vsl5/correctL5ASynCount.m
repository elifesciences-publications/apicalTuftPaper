function [synInfo] = correctL5ASynCount(synInfo,...
    switchCorrectionFactor)
%CORRECTL5ASYNCOUNT This function in used for correction of excitatory and
%inhibitory synapse count for the L5A group. 
% Note: It does not exclude the inhibitory spine synapses since they are
% already integrated into the shaft group. However, the number of these
% synapses are very low


variables = {'Shaft_Count','Spine_Count'};
totalRawSynNumber = sum(synInfo{:,variables},2);

switchCount = synInfo{:,variables}.*switchCorrectionFactor;
% the count of switched spine synapses is moved to the shaft group
% and vice versa
synInfo{:,variables} = synInfo{:,variables}-switchCount+...
    switchCount(:,[2,1]);

assert(...
    all(abs(sum(synInfo{:,variables},2)-totalRawSynNumber)<1e-8),...
    'Sums dont match before and after correction')
end

