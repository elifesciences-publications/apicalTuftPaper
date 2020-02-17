function [] = correlationFigCosmetics(lim,ax)
%CORRELATIONFIG 
plot([0:0.01:lim],[0:0.01:lim],'Color','k')
set(ax,'XLim',[0,lim],'YLim',[0,lim]);
xlabel('Raw');ylabel('corrected');
daspect([1,1,1])
end

