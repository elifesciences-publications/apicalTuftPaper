function [out] = outputForPlot(curResultsTables)
%OUTPUTFORPLOT function returns the diameter, densities 
% (both per pathlength and surface) of synapses for plotting
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

out.diameter=cellfun(@(x) x.apicalDiameter,curResultsTables,...
    'UniformOutput',false);
out.inhDensity=cellfun(@(x) [x.inhSurfDensity,x.inhDensity],curResultsTables,...
    'UniformOutput',false);
out.excDensity=cellfun(@(x) [x.excSurfDensity,x.excDensity],curResultsTables,...
    'UniformOutput',false);
% Go over each field and aggregate the data over different datasets. Only
% the celltype variation is present
f=fieldnames(out);
for i=1:length(f)
    curData=out.(f{i});
    cellTypeNr=size(curData,1);
    aggData=cell(1,cellTypeNr);
    for cellType=1:cellTypeNr
        aggData{cellType}=cat(1,curData{cellType,:});
    end
    out.(f{i})=aggData;
end
end

