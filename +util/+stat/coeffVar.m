function [cv] = coeffVar(array,dim)
%COEFFVAR coefficient of variation, cv= std/mean
cv = nanstd(array,0,dim)./nanmean(array,dim);
end

