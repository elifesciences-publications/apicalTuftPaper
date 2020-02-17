% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
% Get the apicalTuft location
apTuft=apicalTuft.getObjects('l2vsl3vsl5',[],true);

%% PPC2: Plot apical dendritic trees
dist2somaGroups=contains(apTuft.PPC2.groupingVariable.Properties.VariableNames,...
    'dist2soma');
trIndices=table2cell(apTuft.PPC2.groupingVariable(1,dist2somaGroups));
colors=util.plot.getColors().l2vsl3vsl5;
p=dendrite.l2vsl3vsl5.gallery.parametersPPC2;
for g=3:5
    dendrite.l2vsl3vsl5.gallery.saveGallery(apTuft.PPC2,trIndices{g},...
        colors{g},p);
end

%% LPtA: Plot apical dendritic trees
dist2somaGroups=contains(apTuft.LPtA.groupingVariable.Properties.VariableNames,...
    'dist2soma');
% Get tree indices of full apical dendrites and then remove the empty
% groups for the L2MN and L5A
trIndices=table2cell(apTuft.LPtA.groupingVariable(1,dist2somaGroups));
trIndices=trIndices(~cellfun(@isempty,trIndices));

colors={l2color,l3color,l5color};
p=dendrite.l2vsl3vsl5.gallery.parametersLPtA;
for g=1:length(colors)
    dendrite.l2vsl3vsl5.gallery.saveGallery(apTuft.LPtA,trIndices{g},...
        colors{g},p);
end