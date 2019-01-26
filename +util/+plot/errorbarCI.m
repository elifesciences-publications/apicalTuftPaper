function  errorbarCI(CI,color,Xlocation,lineStyle)
%ERRORBARCI Summary of this function goes here
%   Detailed explanation goes here
% INPUT;
%       CI: Nx3 double: lower,middle(lineplot), upper bound of the shade

if ~exist('lineStyle','var') || isempty (lineStyle)
    lineStyle='-';
end
% remove nan locations
idx=~isnan(CI(:,2));
CI=CI(idx,:)';
Xlocation=Xlocation(idx);
errorCI=diff(CI,1,1);
Xlocation=Xlocation+rand(size(Xlocation))*4;
hold on;errorbar(Xlocation,CI(2,:),errorCI(1,:),errorCI(2,:),...
    lineStyle,'Color',color); 
end

