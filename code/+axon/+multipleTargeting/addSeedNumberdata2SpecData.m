function [togetherArray] = addSeedNumberdata2SpecData(axonTracing)
%ADDSEEDNUMBERDATA2SPECDATA Summary of this function goes here
%   Detailed explanation goes here
seedHitting = axonTracing.getSeedTargetingNumber;
spec = axonTracing.getSynRatioComment;
specAndSeedHitting = cat(2,spec,seedHitting(:,2));
togetherArray = specAndSeedHitting{:,2:end};
end

