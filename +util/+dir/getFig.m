function [figDir] = getFig(figID)
%GETFIGDIR Get directories for saving figure panels
% INPUT:
%       figID: Numeric: the id of figure
% OUTPUT:
%       figDir: String: directory for saving the figure
figDir = fullfile(util.dir.getMain,'Figures',['Fig',num2str(figID)]);
util.mkdir(figDir,false);
end

