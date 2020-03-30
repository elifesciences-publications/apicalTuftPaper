%% Fig. 5a, Fig. 5 - Fig. Suppl. 1: Generate the skeleton reconstruction of ADs in PPC-2 and LPtA dataset
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
util.clearAll;
apTuft = apicalTuft.getObjects('l2vsl3vsl5',[],true);
c = util.plot.getColors();

%% PPC-2: Plot apical dendritic trees
dist2somaGroups = ...
    contains(apTuft.PPC2.groupingVariable.Properties.VariableNames,...
    'dist2soma');
trIndices = table2cell(apTuft.PPC2.groupingVariable(1,dist2somaGroups));
colors = c.l2vsl3vsl5;
p = dendrite.l2vsl3vsl5.gallery.parametersPPC2;
for g = 1:5
    dendrite.l2vsl3vsl5.gallery.saveGallery(apTuft.PPC2,trIndices{g},...
        colors{g},p);
end

%% LPtA: Plot apical dendritic trees
dist2somaGroups = ...
    contains(apTuft.LPtA.groupingVariable.Properties.VariableNames,...
    'dist2soma');
% Get tree indices of full apical dendrites and then remove the empty
% groups for the L2MN and L5A
trIndices = table2cell(apTuft.LPtA.groupingVariable(1,dist2somaGroups));
trIndices = trIndices(~cellfun(@isempty,trIndices));

colors = {c.l2color,c.l3color,c.l5color};
p = dendrite.l2vsl3vsl5.gallery.parametersLPtA;
for g = 1:length(colors)
    dendrite.l2vsl3vsl5.gallery.saveGallery(apTuft.LPtA,trIndices{g},...
        colors{g},p);
end