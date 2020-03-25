function [CI] = bootCI(bootfun,sample,varargin)
%BOOTCI Creates a bootstrap confidence interval around the sample data
% OUTPUT:
%       CI: 1x3 double: confidence interval + sample statistic
%   Detailed explanation goes here
nboot = 10000;
sampleStat = bootfun(sample);
stat = bootstrp(nboot,bootfun,sample,varargin{:});
% 95% confidence interval
CIedges = prctile(stat,[2.5,97.5]);
CI = [CIedges(1),sampleStat, CIedges(2)];
end

