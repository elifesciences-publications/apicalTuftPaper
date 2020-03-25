function fromMergerMode( param,nmlMergerModeName,...
    bifurcationSite,outputDirectory,reduceFactor)
% FROMMERGERMODE This Function generates the isosurfaces from the
% 
% INPUT:    param: "p" structure generated by SegEM run
%           nmlMergerModeName: The full name of your mergermode (segment pickup)tracing
%           bifurcationSite: The location which is used to generate the
%           bounding box (20 um^3 length)
%           outputDirectory: Where the isosurfaces are written as .ply
%           files
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
%           Alessandro Motta <Alessandro.motta@brain.mpg.de>
skel = skeleton(nmlMergerModeName);
% Load segIds from output Directory or acquire them if necessary
if ~exist(fullfile(outputDirectory,'segIds.mat'),'file')
    segIds = Skeleton.getSegmentIdsOfSkel(param,skel);
    save(fullfile(outputDirectory,'segIds.mat'),'segIds')
else
    disp('load segIds from matfile...')
    load(fullfile(outputDirectory,'segIds.mat'))
end
if ~exist ('reduceFactor','var') || isempty(reduceFactor)
    reduceFactor = 1;
end
% Bounding boxes from tracings
bboxFromTracingFunc = @(center)util.getBoxFromCenSize(center,20,...
    param.raw.voxelSize).matlab;
bboxesFromTracing = cellfun(bboxFromTracingFunc,bifurcationSite,...
    'UniformOutput',false);
try
    % Get bounding boxes that should be loaded from all datasets
    % bounding boxes from mergermode tracings
    allBboxes = Seg.Global.getSegToBoxMap(param);
    func = @(segIds)Seg.Global.getSegIdListBbox(param,segIds,allBboxes);
    boxPerTreeSeg = cellfun(func,segIds,'UniformOutput',false);
catch
    disp('Error in getting bboxes from the segmentIds')
    boxPerTreeSeg = bboxesFromTracing';
end
% Intersection of the two to get the intersection bounding box
intersectsBbox = cellfun(@util.bbox.intersectBbox,bboxesFromTracing',...
    boxPerTreeSeg,'UniformOutput',false);

% Load the segmentation data, Alessandro snippet:

for tr = 1:skel.numTrees
    util.mkdir(fullfile(outputDirectory,skel.names{tr}));
    % create the binary file
    segData = loadSegDataGlobal(param.seg,intersectsBbox{tr});
    segDataBin = ismember(segData,segIds{tr});
    clear segData
    % smooth size and std from sahil
    smoothingFunc = @(vol) smooth3(vol,'gaussian',9,8);
    segDataSmooth = smoothingFunc(segDataBin);
    clear segDataBin
    %create the isosurface
    isoSurf = isosurface(segDataSmooth,0.2);
    
    % fix order of coordinates
    % dammit MATLAB!
    isoSurf.vertices = reshape(isoSurf.vertices, [], 3);
    isoSurf.vertices = isoSurf.vertices(:, [2, 1, 3]);
    
    % Correct Coordinates
    isoSurf.vertices = bsxfun(...
        @plus, isoSurf.vertices, (intersectsBbox{tr}(:, 1))');
    isoSurf = reducepatch(isoSurf, reduceFactor);
    Visualization.exportIsoSurfaceToAmira(param,isoSurf,...
        fullfile(outputDirectory,skel.names{tr},[skel.names{tr},'.ply']))
    clear isoSurf segDataSmooth
end

end

