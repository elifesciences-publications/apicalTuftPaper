function [colors] = getColors()
%GETCOLORS
colors.l2color=[157/255,157/255,156/255];
colors.l2MNcolor=[0,0,0];
colors.dlcolor=[243/255,146/255,0/255];
colors.l3color=[109,181,70]./255;
colors.l5color=[158,32,103]./255;
colors.l5Acolor=[0,113,188]./255;
colors.exccolor=[1,0,0];
colors.inhcolor=[0,0,1];
colors.small={colors.l2color,colors.dlcolor};
colors.l2vsl3vsl5={colors.l2color;colors.l3color;colors.l5color;...
    colors.l2MNcolor;colors.l5Acolor};
end

