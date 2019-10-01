function [fig1Dir] = getFig6()
% getFig1 Get the directory for Figure 1 related figures. 
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fig1Dir=fullfile(util.dir.getMain,'+Figure6','plot');
util.mkdir(fig1Dir);
end
