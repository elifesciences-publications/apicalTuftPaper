% Fig.1C is also generated using Amira. We use the snippet below to plot
% the same annotations plotted here
% Note: The orientation of the tree does not match the orientation shown in
% the plot.

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

% initial set up, clears all the figures and variables
util.clearAll;
c = util.plot.getColors();
% Tree names used in the figure from the dense bifurcation annotations

trNames = struct();
trNames.s1 = {'layer2ApicalDendrite01','deepLayerApicalDendrite05'};
trNames.v2 = {'layer2ApicalDendrite04','deepLayerApicalDendrite05'};
trNames.ppc = {'layer2ApicalDendrite05','deepLayerApicalDendrite10'};
trNames.acc = {'layer2ApicalDendrite09','deepLayerApicalDendrite07'};
trNames = struct2table(trNames);
% The skeleton reconstruction
bifur = apicalTuft.getObjects('bifurcation');
% Settings
viewAngles = {[0,90],[0,-90],[0,-90],[0,90]};
colors = {c.l2color,c.dlcolor};
fh = figure('Name', 'Fig. 1C');ax = gca;

% Plotting loop
for i = 1:4
    trIdx = bifur{i}.getTreeWithName(trNames{1,i});
    % Only 2 trees per dataset
    assert(length(trIdx) == 2);
    for j = 1:2
        subplot(2,4,4*(j-1)+i)
        bifur{i}.plot(trIdx(j),colors{j});
        bifur{i}.plotSynapses(trIdx(j),[],'sphereSize',20);
        daspect([1,1,1]);
        title(trNames{1,i}{j});
        view(viewAngles{i});
        axis off
    end
end
