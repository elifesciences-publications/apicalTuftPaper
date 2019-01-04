function [fig2Dir] = getFig2()
%GETFIG2 Get the directory for Figure 2 related figures.
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fig2Dir=fullfile(util.dir.getMain,'+Figure2','plot');
util.mkdir(fig2Dir);
end

