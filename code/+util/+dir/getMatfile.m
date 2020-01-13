function [matdir] = getMatfile()
%GETMATFILE get directory for saving the matfiles
matdir = fullfile(util.dir.getAnnotation,'matfiles');
end

