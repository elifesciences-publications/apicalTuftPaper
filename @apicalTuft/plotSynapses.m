function [ synapseObject] = plotSynapses( skel,treeIndices,...
    synCoords,varargin)
%PLOTSYNAPSES Plots the synapses of multiple trees
%INPUT:
%       synCoord: (Optional:synapse coord of all trees) 
%                   Contains the coordinates of all synapses as a table
%       varargin: 
%       scale: 1x3 array scale used to transform voxel to physical
%       coordinate
%       theColormap:colormap used to give each synapse gtoup a specific
%       color (default lines)
%       sphereSize: radius of the sphere used for each synapse
%       For the rest Refer to getSynIdxComment doc
%OUTPUT:
%       synapseObject:structure with tree having it's own field within the
%                       field exists the object array for the scatter sphere
%                       use this to change properties outside the function
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% Setting defaults specific to plotSynapses
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices=1:skel.numTrees;
end
if ~exist('synCoords','var') || isempty(synCoords)
    synCoords=skel.getSynCoord(treeIndices);
    % Annoying property of cell2table results in inhomogenous table need to
    % convert back to cell to be able to do the scale setting
    variableNames=synCoords.Properties.VariableNames;
    synCoords=table2cell(synCoords);
end
optIn.scale=skel.scale;
optIn.theColorMap=colormap(lines);
optIn.sphereSize=100;
optIn = Util.modifyStruct(optIn, varargin{:});


% Object to have the graphics handle for the scatter spheres
synapseObject=struct();
fieldNameFun=@(tr) (['treeId' num2str(tr)]);

% Get and scale synapse coordinates
synCoords(:,2:end)=cellfun(@(coords) skel.setScale(coords,optIn.scale)...
    ,synCoords(:,2:end),'UniformOutput',false);

hold on
% Going through all the trees to be plotted
counterTree=1;
for tr = treeIndices(:)'
    for syType =1:size(synCoords,2)-1
        thisSynCoords=synCoords{counterTree,syType+1};
        % Initialize. the synapse object and coordinate table for this specific
        % tree
        synapseObject.(fieldNameFun(tr))=gobjects(size(synCoords)-[0,1]);
        % Scatter plotting
        synapseObject.(fieldNameFun(tr))(syType) = ...
            scatter3(thisSynCoords(:,1),thisSynCoords(:,2),thisSynCoords(:,3)...
            ,optIn.sphereSize,'filled', 'MarkerEdgeColor', optIn.theColorMap(syType,:), ...
            'MarkerFaceColor', optIn.theColorMap(syType,:));
        % Set the displayName
        synapseObject.(fieldNameFun(tr))(syType).DisplayName = ...
            variableNames{syType+1};
    end
    counterTree=counterTree+1;
end
end

