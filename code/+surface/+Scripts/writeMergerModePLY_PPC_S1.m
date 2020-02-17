% This Script writes out the isosurfaces of the merger mode tracings from 
% S1 and PPC datasets
% Note: You need access to the segmentation data for the S1 and PPC dataset
% to be able to run this script. I have already provided the surfaces as
% .ply files and this is unnecessary.
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

dataset={'ppc','s1'};
for datasetIdx=1:2
    thisdataset=dataset{datasetIdx};
    param=surface.configIsoSurface(thisdataset);
    surface.genIsosurface.fromMergerMode...
        ( param.(thisdataset).p,param.(thisdataset).MergerNml,...
        param.(thisdataset).bifurcationCenter,...
        param.(thisdataset).datasetDir );
end