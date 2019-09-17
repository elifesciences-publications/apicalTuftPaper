function [concatenated] = catL2(l235,other)
%CATL2 Summary of this function goes here
%   Detailed explanation goes here
concatenated=[l235{'layer2ApicalDendrite_mapping','Aggregate'}{1};...
l235{'layer2MNApicalDendrite_mapping','Aggregate'}{1};other];
end

