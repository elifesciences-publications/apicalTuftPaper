function [y] = varfunKeepNames(fun,x,varargin)
% varfunKeepNames, Keep the orignal variable and row names after varfun
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

y = varfun(fun,x,varargin{:});
y.Properties.VariableNames = x.Properties.VariableNames;
if height(y) == height(x)
y.Properties.RowNames = x.Properties.RowNames;
end
end

