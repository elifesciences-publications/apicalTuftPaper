function [] = fromVolumeTracing(p,...
    reduceFactor)
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist ('reduceFactor','var') || isempty(reduceFactor)
    reduceFactor=1;
end

processData.flag=true;
for tr=1:length(p.treeNames)
    % Read the data
    processData.cellID=tr;
    segDataSmooth=surface.genIsosurface.readVolume(p.volAnnotationDir,...
        p.volAnnotationName,p.bbox{tr}, processData);

    % create the isosurface
    isoSurf=isosurface(segDataSmooth,0.2);
    
    % fix order of coordinates
    % dammit MATLAB!
    isoSurf.vertices = reshape(isoSurf.vertices, [], 3);
    isoSurf.vertices = isoSurf.vertices(:, [2, 1, 3]);
    
    % Correct Coordinates
    isoSurf.vertices = bsxfun(...
        @plus, isoSurf.vertices, (p.bbox{tr}(:, 1))');
    isoSurf = reducepatch(isoSurf, reduceFactor);
    util.mkdir(fullfile(p.outputDirectory,p.treeNames{tr}));
    Visualization.exportIsoSurfaceToAmira(p,isoSurf,...
        fullfile(p.outputDirectory,p.treeNames{tr},...
        [p.treeNames{tr},'.ply']));
    clear isoSurf segDataSmooth
end
end

