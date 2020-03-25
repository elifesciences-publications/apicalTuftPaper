function addL5AUncorrected(xLoc,results,location)
%ADDL5AUNCORRECTED add uncorrected L5A synapse densities to boxplot figure
% Make sure order of corrected and uncorrected values match
xLoc = cat(2,xLoc{end-1:end})';
L5Ahorizontal = xLoc(:,1);
L5Auncorrected = [results.l235.(location){end}.excSurfDensity_uncorrected,
    results.l235.(location){end}.inhSurfDensity_uncorrected];
L5Acorrected = [results.l235.(location){end}.excSurfDensity,
    results.l235.(location){end}.inhSurfDensity];
assert( isequal(xLoc(:,2),L5Acorrected) );
% Plot the uncorrected L5A values as grey crosses and connect them with a
% line
dendrite.L5A.plotUncorrected(L5Auncorrected, L5Acorrected,...
    L5Ahorizontal)
end

