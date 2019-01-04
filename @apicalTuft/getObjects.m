function [skel] = getObjects(type,configName,returnTable)
% GETBIFURCATIONOBJECTS returns the objects of the "type" of
% apical dendrite tracing as a cell array
% See nmlName method for available
% INPUT: 
%       type: string having the name of annotation type as defined in
%       nmlName method
% OUTPUT:
%       skel: [1xN] cell array of apicalTuft objects of the annotation type
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if isempty(apicalTuft.nmlName.(type))
    error(['annotation type does not exist:',type]);
end
if ~exist('configName','var') || isempty(configName)
    configName = [];
end
if ~exist('returnTable','var') || isempty(returnTable)
    returnTable=false;
end
numDatasets=length(apicalTuft.nmlName.(type));
skel=cell(1,numDatasets);
variableNames=cell(1,numDatasets);
for dataset=1:length(apicalTuft.nmlName.(type))
    % Object construction
    skel{dataset}=apicalTuft(apicalTuft.nmlName.(type){dataset},configName);
    variableNames{dataset}=skel{dataset}.dataset;
end
if returnTable
skel=cell2table(skel,'VariableNames',variableNames);
end
end

