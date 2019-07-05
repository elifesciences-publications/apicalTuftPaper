% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
RotMatrix=dendrite.l2vsl3vsl5.getRotationMatrixPPC2;
% Get the apicalTuft location
apTuft=apicalTuft('PPC2WeirdV1_l2vsl3vsl5');
l1piaGrid=skeleton(fullfile...
    (util.dir.getAnnotation,'l2vsl3vsl5','L1PiaGrid'));

% Plot L5 apical dendritic trees
trIndices=apTuft.getTreeWithName('layer5ApicalDendrite_dist2soma','first');
hold on
apTuft.plot(trIndices,[],[],[],[],[],[],[],RotMatrix);
dendrite.l2vsl3vsl5.plotBorderGrids(l1piaGrid,RotMatrix)
daspect([1,1,1]);
view([90 0]);camroll(-180);
hold off
figure
hold on
apTuft.plot(trIndices);
dendrite.l2vsl3vsl5.plotBorderGrids(l1piaGrid)
daspect([1,1,1]);
view([90 0]);camroll(-90);
hold off