function [cv] = coeffVar(array,dim)
% COEFFVAR coefficient of variation, cv = std/mean

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
cv = nanstd(array,0,dim)./ nanmean(array,dim);
% Covert to percent and round
cv = round(cv.*100,2);
end

