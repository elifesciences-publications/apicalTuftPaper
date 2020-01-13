function [matdir] = getMatfile()
%GETMATFILE get directory for saving the matfiles
matdir = fullfile(util.dir.getMain,'Other','matfiles');
end

