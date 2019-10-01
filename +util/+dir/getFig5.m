function [fig1Dir] = getFig5()
% getFig1 Get the directory for Figure 1 related figures. 
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fig1Dir=fullfile(util.dir.getMain,'+Figure5','plot');
util.mkdir(fig1Dir);
end

