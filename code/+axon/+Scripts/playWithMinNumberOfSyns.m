%% figure 2b
numbereOfMinsyn=[0];
for n=numbereOfMinsyn
    
    idxL2=find(synTable{5,1}.totalSynapseNumber>n);
    idxDL=find(synTable{5,2}.totalSynapseNumber>n);
    
    Xpositions=[1.5:2:9];
    noise=1.3;
    spec{1}=synRatio{5,1}.L2Apical(idxL2,:);
    spec{2}=synRatio{5,2}.L2Apical(idxDL,:);
    spec{3}=synRatio{5,2}.DeepApical(idxDL,:);
    spec{4}=synRatio{5,1}.DeepApical(idxL2,:);
    specWithNoisyX=cellfun(@(array,position)use.addNoisyX(array,position,noise),...
        spec(:),num2cell(Xpositions)','UniformOutput',false);
    
    fh=figure;ax=gca;
    hold on;
    cellfun(@(x,y)boxplot(x,'Positions',y,'Colors','k','Widths',1.5,'Symbol',''),...
        spec(:),num2cell(Xpositions)');
    set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
    colors={l2color,dlcolor,dlcolor,l2color}';
    cellfun(@(x,y)use.scatter(x,y),specWithNoisyX,colors);
    
    
    %Figure properties
    set(ax,'xtick',[],'XLim',[0.2 8.3],...
        'Ylim',[0 1],'LineWidth',1, 'xtick',[])
    
    %Saving parameters
    x_width=9;
    y_width=7;
    fh = setFigureHandle(fh,'height',y_width,'width',x_width);
    ax = setAxisHandle(ax);
    saveas(fh,fullfile(figure2Dir,'playWithMinNumberof Syns',...
        sprintf('apicalSpec_%0.2u',n)),'svg')
    
    [p,h,~]=ranksum(spec{1},spec{2});
    fprintf(['L2Specificity',' Wilcoxon ranksum - h=%d, p=%d\n'], h,p);
    [p,h,~]=ranksum(spec{3},spec{4});
    fprintf(['DeepSpecificity',' Wilcoxon ranksum - h=%d, p=%d\n'], h,p);
    
    
end