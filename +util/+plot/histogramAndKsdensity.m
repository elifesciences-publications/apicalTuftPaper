function histogramAndKsdensity(data,color)
hold on
yyaxis left
histogram(data,...
    0:0.1:1,'FaceColor',[1,1,1],'FaceAlpha',0,'EdgeColor',color);
yyaxis right
util.plot.ksdensity(data,color,0.0573,[0-1e-5 1+1e-5]);
hold off
end
