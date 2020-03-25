% Write isosurfaces as ply files for the volume annotations in v2 and acc
% datasets
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

dataset = {'v2','acc'};

for datasetIdx = 1:2
    p = surface.config_V2_ACC(dataset{datasetIdx});
    surface.genIsosurface.fromVolumeTracing(p);
end