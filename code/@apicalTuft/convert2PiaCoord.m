function [obj] = convert2PiaCoord(obj,treeIndices)
%CONVERT2PIACOORD This function converts the coordinates to rounded NM
%values; In addition, the y axis corresponds to distance from pia
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% OUTPUT:
%       obj: corrected coordinate in the nodes, nodesNumDataAll and
%       nodesAsStruct Properties of the class
% Default
if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:obj.numTrees;
end

for tr = treeIndices(:)'
    convertedCoord = convertCoord(obj,obj.nodes{tr}(:,1:3));
    % Update nodes, nodesNumDataAll and nodesAsStruct properties to new
    % coords
    obj.nodes{tr}(:,1:3) = convertedCoord;
    obj.nodesNumDataAll{tr}(:,3:5) = convertedCoord;
    pre = obj.nodesAsStruct{tr};
    nodesInfoCell = squeeze(struct2cell(obj.nodesAsStruct{tr}));
    nodesInfoCell(3:5,:) = arrayfun(@num2str,convertedCoord', ...
        'UniformOutput', false);
    obj.nodesAsStruct{tr} = cell2struct(nodesInfoCell,...
        fieldnames(obj.nodesAsStruct{tr}),1)';
    post = obj.nodesAsStruct{tr};
    % Nodes size check
    assert(isequal(size(pre),size(post)));
end
% correct the object scale and pia-WM dimension after making the Y axis P-W
% axes in NM
obj.scale = [1,1,1];
obj.datasetProperties.dimPiaWM = 2;

    function coordCorrected = convertCoord(obj,coord)
        % Convert 2 nanometer
        coordInNM = ...
            bsxfun(@times,coord,obj.scale);
        % Make sure the Y axis corresponds to Pia-WM axis
        coordDirectionCorrected = coordInNM*obj. ...
            datasetProperties.correction(2:end,:);
        % y = 0 should be pia
        y0VoxelDistFromPia = ...
            obj.datasetProperties.correction(1,:)*1000;
        coordCorrected = ...
            round(bsxfun(@plus,coordDirectionCorrected,y0VoxelDistFromPia));
    end
end

