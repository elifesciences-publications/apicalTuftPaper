function [fig7Dir] = getFig7()
% getFig1 Get the directory for Figure 1 related figures. 
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fig7Dir=fullfile(util.dir.getMain,'+Figure7','plot');
util.mkdir(fig7Dir);
end
