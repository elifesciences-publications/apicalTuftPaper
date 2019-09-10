function [Rsquared] = coeffDetermination(modelfun,data)
% COEFFDETERMINATION Measure the coefficient of determination
X=data(:,1);
Y=data(:,2);
modelY=modelfun(X);
SSres=sum( (Y-modelY).^2 ,'all');
SStot=sum( (Y-mean(Y)).^2 );

Rsquared=1-(SSres/SStot);
end

