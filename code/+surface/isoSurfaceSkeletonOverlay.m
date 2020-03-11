function isoSurfaceSkeletonOverlay( skel,skelBackBone,dataset,l2color,dlcolor)
% Get the isosurfaces
nameFun = @(treeName)fullfile(util.dir.getSurface,dataset,...
    treeName,[treeName,'.ply']);
plyNames = cellfun(nameFun,skel.names,'UniformOutput',false);
isoSurf = cellfun(@Visualization.readPLY,plyNames,'UniformOutput',false);
color = cell(1,skel.numTrees);
color(skel.l2Idx) = {l2color};
color(skel.dlIdx) = {dlcolor};

for tr = 1:skel.numTrees
    figure()
    % Make a debugging plot
    skelBackBone.plot(tr,color{tr});
    skel.plotSynapses(tr,[],...
        'theColorMap',[0,0,1;1,0,0;0,0,1]);
    surface.draw(isoSurf{tr},'color',color{tr});
end
end

