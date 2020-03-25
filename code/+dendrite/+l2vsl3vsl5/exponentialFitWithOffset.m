function [mdl] = exponentialFitWithOffset(X,Y,beta0)
%EXPONENTIALFITWITHOFFSET This function creates an exponential fit to data
% with offset, the initial guess is taken from a double exponential fit
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('beta0','var') || isempty (beta0)
    % Use parameters from a double exponential fit as starting guess
    exp2 = fit(X,Y,'exp2');
    beta0 = [exp2.c,exp2.a,exp2.b];
end
modelfun = @(b,x)(b(1)+b(2)*exp(b(3)*x));
mdl = fitnlm(X,Y,modelfun,beta0);
end

