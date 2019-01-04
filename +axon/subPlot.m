function [] = subPlot(featureArray,listOfFeatures,endEdge)
%Create the
%Define basic parameters
clf
if ~exist('endEdge','var') || isempty(endEdge)
    getEndEdge=true;
else
    getEndEdge=false;
end
lumpedDataRow=5;
l2color=[0.8 0.8 0.8];
dlcolor=[0.9 0.14 0];
nrOfbins=25;
nrDataRow=size(featureArray,1)+1;
nrFeatureCol=length(listOfFeatures);

featureNames=listOfFeatures;%{'PathLength[um]','Total synapse number','Synapse Density[1/um]'};
dataTypes={'S1','V2','PPC','ACC','Lumped','Exc PPC'};
PlotNum=1;
for data=1:nrDataRow-1
    for feature=1:nrFeatureCol
        % Get the edges for the bins of histogram and the limits in x
        if getEndEdge
            endEdge=max([featureArray{lumpedDataRow,1}.(listOfFeatures{feature});...
                featureArray{lumpedDataRow,2}.(listOfFeatures{feature})]);
            endEdge=endEdge+(1/nrOfbins)*endEdge;
        end
        edges=linspace(0,endEdge,nrOfbins);
        
        % Plotting histogram
        subplot(nrDataRow,nrFeatureCol,PlotNum)
        hold on
        histogram(ignoreNan(featureArray{data,1}.(listOfFeatures{feature})), edges,...
            'Normalization', 'probability', 'facecolor',l2color,...
            'facealpha',.5,'edgecolor','k')
        histogram(ignoreNan(featureArray{data,2}.(listOfFeatures{feature})), edges, ...
            'Normalization', 'probability', 'facecolor',dlcolor,...
            'facealpha',.6,'edgecolor','none')
        %Xlabel and ylabel only at the edges
        if data==1
            title(featureNames{feature})
        end
        if feature==1
            ylabel(dataTypes{data})
        end
        set(gca, 'FontSize', 10, 'FontName', 'Arial');
        set(gca, 'TickDir', 'out','Box','off');
        xlim([0 endEdge])
        ylim([0 1])
        
        if data==lumpedDataRow
            subplot(nrDataRow,nrFeatureCol,PlotNum+nrFeatureCol)
            if feature==1
                ylabel('KernelDensity Lumped')
            end
            hold on
            [xl2,yl2]=ksdensity(ignoreNan(featureArray{data,1}.(listOfFeatures{feature})), ...
                edges);
            [xdl,ydl]=ksdensity(ignoreNan(featureArray{data,2}.(listOfFeatures{feature})),...
                edges);
            plot(yl2,xl2,'Color','k','LineWidth',1.5);
            plot(ydl,xdl,'Color',dlcolor,'LineWidth',1.5);
            hold off
        end
        PlotNum = PlotNum + 1;
    end
    if data==lumpedDataRow
        PlotNum = PlotNum + nrFeatureCol;
    end
    legend('L2 PYR','DL PYR');
end

