function [pia] = loadPia()
%LOADPIA load pia surface in PPC2 dataset taken from LM data
m = load(fullfile(util.dir.getMatfile,'pia.mat'));
pia = m.pia;
end

