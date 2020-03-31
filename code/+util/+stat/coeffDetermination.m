function [Rsquared] = coeffDetermination(modelfun,data,numParams)
% COEFFDETERMINATION Measure the coefficient of determination
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
X = data(:,1);
Y = data(:,2);
modelY = modelfun(X);
SSres = sum((Y-modelY).^2 ,'all');
SStot = sum((Y-mean(Y)).^2 );
numSamples = length(X);
Rsquared.ordinal = 1-(SSres/SStot);
Rsquared.adjusted = 1-((numSamples-1)/(numSamples-numParams))*(SSres/SStot);
end

