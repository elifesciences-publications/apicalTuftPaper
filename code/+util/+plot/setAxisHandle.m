function [ h ] = setAxisHandle( h, colorToBlack,xtickMinor,ytickMinor)
% SETAXISHANDLE Setting for figure axis
% Author: florian drawitsch<florian.drawitsch@brain.mpg.de>
% modified: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('colorToBlack','var') || isempty(colorToBlack)
    colorToBlack = 1;
end
if ~exist('ytickMinor','var') || isempty(ytickMinor)
    ytickMinor = 'off';
end
if ~exist('xtickMinor','var') || isempty(xtickMinor)
    xtickMinor = 'off';
end
% normalize the axis inner size
set(h,'Units','normalized', 'Position',[0.25 0.25 0.5 0.5]);
set(h,'FontName','Arial')
set(h,'FontSize',8)
set(h,'Box','off')
set(h,'LineWidth',0.5)
set(h,'TickDir','out')
set(h,'XMinorTick',xtickMinor)
set(h,'YMinorTick',ytickMinor)
% For doubleY axis as in yyaxis
if length(h.YAxis) == 2
    yyaxis left
    set(h,'YMinorTick',ytickMinor)
    yyaxis right
    set(h,'YMinorTick',ytickMinor)
end
set(h,'TickLength',[0.03 0.075])
if colorToBlack
    set(h,'GridColor',[0 0 0])
    set(h,'MinorGridColor',[0 0 0])
    set(h,'XColor',[0 0 0])
    set(h,'YColor',[0 0 0])
    % For doubleY axis as in yyaxis
    if length(h.YAxis) == 2
        h.YAxis(2).Color = [0,0,0];
        h.YAxis(1).Color = [0,0,0];
    end
end

end

