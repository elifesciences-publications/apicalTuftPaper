function [] = plotDense(Dataset)
% Author: Jan Odenthal <jan.odenthal@brain.mpg.de>

% L2
allTrees = Dataset.l2Idx;
figure();
hold on
    for tr = allTrees
        Figure7.SupplA.plotStretched(Dataset, tr, 'L2', allTrees);
    end
    util.plot.setFigureHandle(gcf,'width',24,'height',7);
    set(gca, 'Ydir', 'reverse')
    set(gca, 'TickLength', [0,0], 'FontSize', 20)
    set(gca, 'XTick', [], 'YTick', ...
        [0:20:300], 'YTickLabels',...
        {'0', '20', '40', '60', '80', '100', '120', '140', '160', ...
        '180', '200', '220', '240', '260', '280', '300'});
    view([0,0,1])
    axis equal
    grid on
    set(gcf,'renderer','painters');
    ylim([0, 320])
    xlim([0, 1500])
hold off 
drawnow;
% L5
allTrees = Dataset.dlIdx;
figure();
hold on
    for tr = allTrees
        Figure7.SupplA.plotStretched(Dataset, tr, 'Deep', allTrees);
    end
    util.plot.setFigureHandle(gcf,'width',24,'height',7);
    set(gca, 'Ydir', 'reverse')
    set (gca, 'TickLength', [0,0], 'FontSize', 20)
    set(gca, 'XTick', [], 'YTick',[0:20:300] , 'YTickLabels', ...
        {'0', '20', '40', '60', '80', '100', '120', '140', '160', ...
        '180', '200', '220', '240', '260', '280', '300'});
    view([0,0,1])
    axis equal
    grid on
    set(gcf,'renderer','painters');
    ylim([0, 320])
    xlim([0, 1500])
hold off
drawnow;
end