function shade(mean,sem,color,Xlocation,lineStyle)

if ~exist('lineStyle','var') || isempty (lineStyle)
    lineStyle = '-';
end
idx = ~isnan(mean);
fill([Xlocation(idx) fliplr(Xlocation(idx))],...
[mean(idx)+sem(idx) fliplr(mean(idx)-sem(idx))],color,...
 'FaceAlpha', 0.2, 'LineWidth',0.01, 'EdgeColor', 'none');    
hold on;plot(Xlocation,mean,lineStyle,'Color',color); 

end


