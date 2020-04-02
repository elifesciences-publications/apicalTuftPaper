function [] = plotDense2(Dataset)
% Author: Jan Odenthal <jan.odenthal@brain.mpg.de>
%L2
allTrees = Dataset.groupingVariable.layer2ApicalDendrite_mapping{1};
depths = 0:20:300;
depthStrings = arrayfun(@num2str,depths,'uni',0);
xLim = [0, 1500];
figure()
hold on
    for tr = allTrees'
        Figure7.SupplA.plotStretched(Dataset, tr, 'L2', allTrees);
    end
    util.plot.setFigureHandle(gcf,'width',24,'height',7)
    set(gca, 'Ydir', 'reverse')
    set(gca, 'TickLength', [0,0], 'FontSize', 20)
    set(gca, 'XTick', [], 'YTick', depths, 'YTickLabels', depthStrings);
    view([0,0,1])
    axis equal
    grid on
    set(gcf,'renderer','painters');
    ylim([0, 320])
    xlim(xLim)
hold off 
drawnow
%L3
allTrees = Dataset.groupingVariable.layer3ApicalDendrite_mapping{1};
figure()
hold on
    for tr = allTrees'
         Figure7.SupplA.plotStretched(Dataset, tr, 'L3', allTrees);
    end
    util.plot.setFigureHandle(gcf,'width',24,'height',7)
    set(gca, 'Ydir', 'reverse')
    set(gca, 'TickLength', [0,0], 'FontSize', 20)
    set(gca, 'XTick', [], 'YTick', depths, 'YTickLabels', depthStrings);
    view([0,0,1])
    axis equal
    grid on
    set(gcf,'renderer','painters');
    ylim([0, 320])
    xlim(xLim)
hold off 
drawnow
%L5
allTrees = Dataset.groupingVariable.layer5ApicalDendrite_mapping{1};
figure()
hold on
    for tr = allTrees'
        Figure7.SupplA.plotStretched(Dataset, tr, 'L5', allTrees);
    end
    util.plot.setFigureHandle(gcf,'width',24,'height',7)
    set(gca, 'Ydir', 'reverse')
    set(gca, 'TickLength', [0,0], 'FontSize', 20)
    set(gca, 'XTick', [], 'YTick', depths, 'YTickLabels', depthStrings);
    view([0,0,1])
    axis equal
    grid on
    set(gcf,'renderer','painters');
    ylim([0, 320])
    xlim(xLim)
hold off
drawnow
end