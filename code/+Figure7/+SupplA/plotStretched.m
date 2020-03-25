function h = plotStretched(Dataset, tr, groupString, trees)
% Author: Jan Odenthal <jan.odenthal@brain.mpg.de>
if length(trees) >= 5
    stretchFactor = 100;
else
    stretchFactor = 500; %200
end

%We don't want the trees to overlap, so we shift them on the x-Axis by shiftFactor*stretchFactor.
%With every tree, the shiftFactor increases by 1.
switch groupString
    case 'Deep'
        shiftFactor = evalin('base', 'shiftFactorDeep');
        assignin('base', 'shiftFactorDeep', shiftFactor+1);
    case 'L5'
        shiftFactor = evalin('base', 'shiftFactorL5');
        assignin('base', 'shiftFactorL5', shiftFactor+1);
    case 'L3'
        shiftFactor = evalin('base', 'shiftFactorL3');
        assignin('base', 'shiftFactorL3', shiftFactor+1);
    case 'L2'
        shiftFactor = evalin('base', 'shiftFactorL2');
        assignin('base', 'shiftFactorL2', shiftFactor+1);
end

shCoords = Figure7.SupplA.synapseCoordinates(Dataset, tr, {'Shaft', 'spineDoubleInnervated', 'spineNeck'});
spCoords = Figure7.SupplA.synapseCoordinates(Dataset, tr, {'spineSingleInnervated'});

%We also use the smallest x-Coordinate of all Synapses to normalize the
%position of the tree. Figuratively speaking, we shift the tree to the left
%until it just touches the y-axis and then we whift it to the right by
%shiftfactor*stretchfactor.

allEdges = bsxfun(@times,Dataset.nodes{tr}(:,1:3),Dataset.scale);

if ~isempty(spCoords)
    for ed = 1:size(Dataset.edges{tr},1)
        edge = Dataset.edges{tr}(ed,:);
        stringColor = 'k';
        h = plot3(allEdges(edge,1)/1000-min(spCoords(:,1))/1000+...
            shiftFactor*stretchFactor,allEdges(edge,2)/1000,...
            allEdges(edge,3)/1000,...
            '-','Color',stringColor,'LineWidth',0.25);
        hold on
    end
else
    if ~isempty(shCoords)
        for ed = 1:size(Dataset.edges{tr},1)
            edge = Dataset.edges{tr}(ed,:);
            stringColor = 'k';
            h = plot3(allEdges(edge,1)/1000-min(shCoords(:,1))/1000+...
                shiftFactor*stretchFactor,allEdges(edge,2)/1000,...
                allEdges(edge,3)/1000,...
                '-','Color',stringColor,'LineWidth',0.25);
            hold on
        end
    end
end

%We do the same corrections for the synapse postitions and then plot them:
scatter3(spCoords(:,1)/1000-min(spCoords(:,1)/1000)+...
    shiftFactor*stretchFactor,spCoords(:,2)/1000,...
    spCoords(:,3)/1000,1.7,'filled','r');
scatter3(shCoords(:,1)/1000-min(spCoords(:,1)/1000)+...
    shiftFactor*stretchFactor,shCoords(:,2)/1000,...
    shCoords(:,3)/1000,1.7,'filled','b');
end