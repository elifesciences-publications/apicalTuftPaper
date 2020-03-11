function [] = displaySynGroups(axon)
%SYNGROUP Summary of this function goes here
%   Detailed explanation goes here
for group = 1:length(axon.synGroups)
    disp(["Group "+sprintf("%0.2u:",group);axon.syn(axon.synGroups{group})']);
end
    disp(["All:";axon.syn']);

end

