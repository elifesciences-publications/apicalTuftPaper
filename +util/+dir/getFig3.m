function [fig3Dir] = getFig3()
% getFig3 Get the directory for Figure 3 related figures. 
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

fig3Dir=fullfile(util.dir.getMain,'+Figure3','plot');
util.mkdir(fig3Dir);
end

