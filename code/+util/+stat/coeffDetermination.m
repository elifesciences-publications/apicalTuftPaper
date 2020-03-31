function [Rsquared] = coeffDetermination(modelfun,data,numParams)
% COEFFDETERMINATION Measure the coefficient of determination
% based on the definition here:
% https://de.mathworks.com/help/stats/coefficient-of-determination-r-squared.html

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
X = data(:,1);
Y = data(:,2);
modelY = modelfun(X);
% sum of residuals of Model
SSres = sum((Y-modelY).^2 ,'all');
% sum of residuals of the mean (total residuals)
SStot = sum((Y-mean(Y)).^2);
numSamples = length(X);
% Get the ordinal and adjusted (to model parameters) R^2
Rsquared.ordinal = 1-(SSres/SStot);
Rsquared.adjusted = 1-((numSamples-1)/(numSamples-numParams))*(SSres/SStot);
end

