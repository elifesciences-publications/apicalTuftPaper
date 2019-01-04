function [measure] = datasetFun(fun,JsonFileName,layerSpecific,nmlFileNames)
% Iterates a methods of the apicalTuft class over the nml tracings defined
% by the JsonFileName cell array
if nargin<3
    layerSpecific=true;
end
if nargin<4
    nmlFileNames=JsonFileName;
end

numberOfDatasets=length(JsonFileName);

if layerSpecific
    measure=cell(2,numberOfDatasets+1);
    for dataset=1:length(JsonFileName)
        skel=apicalTuft(nmlFileNames{dataset},JsonFileName{dataset});
        %   Calculate the measure
        if ~isempty(skel.l2Idx)
            measure{1,dataset}=skel.(fun)(skel.l2Idx);
        end
        if ~isempty(skel.dlIdx)
            measure{2,dataset}=skel.(fun)(skel.dlIdx);
        end
    end
    measure{1,numberOfDatasets+1}=cat(1,measure{1,1:numberOfDatasets});
    measure{2,numberOfDatasets+1}=cat(1,measure{2,1:numberOfDatasets});
else
    measure=cell(1,numberOfDatasets+1);
    for dataset=1:numberOfDatasets
        skel=apicalTuft(JsonFileName{dataset});
        
        %   Get the specific Measurement
        measure{1,dataset}=skel.(fun);
    end
    measure{1,numberOfDatasets+1}=cat(1,measure{1,1:numberOfDatasets});
end
end

