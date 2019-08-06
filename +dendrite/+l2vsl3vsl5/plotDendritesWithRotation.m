% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
% Get the apicalTuft location
apTuft=apicalTuft('PPC2_l2vsl3vsl5');
l1piaGrid=skeleton(fullfile...
    (util.dir.getAnnotation,'l2vsl3vsl5','L1PiaGrid'));

%% Plot apical dendritic trees
dist2somaGroups=contains(apTuft.groupingVariable.Properties.VariableNames,...
    'dist2soma');
trIndices=table2cell(apTuft.groupingVariable(1,dist2somaGroups));
colors=util.plot.getColors().l2vsl3vsl5;
for g=1:5
    dendrite.l2vsl3vsl5.saveGallery_PPC2(apTuft,trIndices{g},...
        colors{g});
end
