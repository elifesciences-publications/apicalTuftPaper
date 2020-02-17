function [matdir] = getMatfile()
%GETMATFILE get directory for saving the matfiles
matdir = fullfile(util.dir.getMain,'data','Other','matfiles');
util.mkdir(matdir);
end

