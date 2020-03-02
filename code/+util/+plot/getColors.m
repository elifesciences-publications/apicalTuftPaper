function [colors] = getColors()
% GETCOLORS return structure with the most common RGB values used
% Note use: c = util.plot.getColors();
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

colors.l2color=[157/255,157/255,156/255];
colors.l2MNcolor=[0,0,0];
colors.dlcolor=[243/255,146/255,0/255];
colors.l3color=[109,181,70]./255;
colors.l5color=[158,32,103]./255;
colors.l5Acolor=[0,113,188]./255;
colors.exccolor=[195,0,23]./255;
colors.inhcolor=[46,49,144]./255;
colors.small={colors.l2color,colors.dlcolor};
colors.l2vsl3vsl5={colors.l2color;colors.l3color;colors.l5color;...
    colors.l2MNcolor;colors.l5Acolor};
colors.colorsCortex={[0.2 0.2 0.2],[227/255 65/255 50/255],...
    [50/255 205/255 50/255],[50/255 50/255 205/255]}';
end

