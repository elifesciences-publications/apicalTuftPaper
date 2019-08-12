function [out]=nmlName()
% returns the names of the nml files from different tracing types
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
nameFun=@(datasetName,annotationType) [datasetName,'_',annotationType];
smallDatasets={'S1','V2','PPC','ACC'};
% Apical dendrite diameter measurements
out.apicalDiameter=cellfun(nameFun,smallDatasets,...
    repmat({'apicalDiameter'},1,4),'uni',0);
out.l2vsl3vsl5Diameter=cellfun(nameFun,{'PPC2','LPtA','PPC2L5ADistal'},...
    repmat({'l2vsl3vsl5Diameter'},1,3),'uni',0);
out.bifurcationDiameter=cellfun(nameFun,smallDatasets,...
    repmat({'bifurcationDiameter'},1,4),'uni',0);
% Distance to soma in small datasets
out.dist2Soma=cellfun(nameFun,smallDatasets,...
    repmat({'dist2Soma'},1,4),'uni',0);
% Dense input mapping
out.bifurcation=cellfun(nameFun,smallDatasets,...
    repmat({'bifurcation'},1,4),'uni',0);
out.l2vsl3vsl5={'PPC2_l2vsl3vsl5','LPtA_l2vsl3vsl5',...
    'PPC2L5ADistal_l2vsl3vsl5'};
out.wholeApical=cellfun(nameFun,smallDatasets,...
    repmat({'wholeApical'},1,4),'uni',0);
% Axonal annotations
out.inhibitoryAxon=cellfun(nameFun,smallDatasets,...
    repmat({'inhibitoryAxon'},1,4),'uni',0);
out.spineRatioMappingL1={'LPtAspineSeeded_spineRatioMappingL1',...
    'LPtAshaftSeeded_spineRatioMappingL1'};
out.spineRatioMappingL2={'V2spineSeeded_spineRatioMappingL2',...
    'PPCspineSeeded_spineRatioMappingL2',...
    'ACCspineSeeded_spineRatioMappingL2'};
out.L5ARatioMapping={'PPC2L1_L5ARatioMapping','PPC2L2_L5ARatioMapping'};


end
