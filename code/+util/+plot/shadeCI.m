function shadeCI(CI,color,Xlocation,lineStyle)
%SHADECI plots shade with a CI input
% INPUT;
%       CI: Nx3 double: lower,middle(lineplot), upper bound of the shade

if ~exist('lineStyle','var') || isempty (lineStyle)
    lineStyle = '-';
end
% remove nan locations
idx = ~isnan(CI(:,2));
CI = CI(idx,:)';
Xlocation = Xlocation(idx);
fill([Xlocation fliplr(Xlocation)],...
[CI(1,:) fliplr(CI(3,:))],color,...
 'FaceAlpha', 0.2, 'LineWidth',0.01, 'EdgeColor', 'none');    
hold on;plot(Xlocation,CI(2,:),lineStyle,'Color',color); 
end

