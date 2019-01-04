function shade(mean,sem,color,F,lineStyle)

if ~exist('lineStyle','var') || isempty (lineStyle)
    lineStyle='-';
end
idx=~isnan(mean);
fill([F(idx) fliplr(F(idx))],...
[mean(idx)+sem(idx) fliplr(mean(idx)-sem(idx))],color,...
 'FaceAlpha', 0.2, 'LineWidth',0.01, 'EdgeColor', 'none');    
hold on;plot(F,mean,lineStyle,'Color',color); 

end


